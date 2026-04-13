//
//  PetViewModel.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import Foundation
import SwiftUI
import Combine

@Observable
class PetViewModel: ObservableObject {
    var player: Player?
    var shop: Shop?
    var petTypes: [String: PetType] = [:]
    var items: [String: Item] = [:]
    private var timer:Timer = Timer()
    private let dbUtil: DBUtilities
    private let authService: AuthService
    
    private var timeUnit = 1.0 // 60 = to Minutes, 1 = to Seconds
    private var decayInterval = 10 // timeUnits
    
    private var userID: String {
        self.player?.id ?? ""
    }
    
    init(dbUtil: DBUtilities, authStatus: AuthService){
        self.dbUtil = dbUtil
        self.authService = authStatus
        
        print("PVM INIT ", ObjectIdentifier(self))
    }
    
    func petTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true){ _ in
            
            Task{ @MainActor in
                await self.updatePetDecay()
            }
        }
    }
    
    func updatePetDecay() async {
        guard self.player != nil else { return }
        guard self.player?.pet != nil else { return }
        let lastPetUpdated = self.player?.pet?.lastUpdate ?? nil
        let timeSincePetUpdate = Date().timeIntervalSince(lastPetUpdated!) / timeUnit
        let intervalsSincePetUpdate = Int(floor(timeSincePetUpdate / Double(self.decayInterval)))
        let typeID = self.player!.pet!.typeID
        
        self.player?.currency += 100 * intervalsSincePetUpdate
        self.player?.pet?.decayPetStats(type: self.petTypes[typeID]!, intervals: intervalsSincePetUpdate)

        do{
            try await self.dbUtil.updatePlayer(userID: self.player!.id, player: self.player!)
            try await self.dbUtil.updatePet(userID: self.player!.id, pet: self.player!.pet!)
        } catch {
            print("Error updating pet decay")
        }
    }
    
    func newPet(name: String, typeID: String) async{
        guard self.player?.pet == nil else { return }
        print("BEFORE NEW PET")
        print(ObjectIdentifier(self.player!))
        await self.dbUtil.addPet(userID: userID, name: name, typeID: typeID)
        await initPet(userID: userID)
    }
    
    func buyItem(_ shopItem: ShopItem) {
        ConnectionManager.shared.sendData(object: shopItem) { _ in
            print("Buy Item Error")
        }
        
        if self.player?.currency ?? 0 >= shopItem.price, shopItem.quantity == nil || shopItem.quantity! > 0{
            Task{ @MainActor in
                    self.player?.currency -= shopItem.price
                    self.player?.inventory?.addItem(shopItem.id, self.player!.id)
                    if shopItem.quantity != nil && shopItem.quantity! > 0 {
                        self.shop?.removeItem(shopItem.id)
                    }
                    
                    do{
                        try await self.dbUtil.updatePlayer(userID: userID, player: self.player!)
                        try await self.dbUtil.updateInventoryItem(invItem: self.player!.inventory!.getItem(shopItem.id))
                        try await self.dbUtil.updateInventory(userID: userID, inventory: self.player!.inventory!)
                        try await self.dbUtil.updateShopItem(shopItem: self.shop!.items[shopItem.id]!)
                        try await self.dbUtil.updateShop(shopID: self.shop!.id, shop: self.shop! )
                    } catch { print("ERROR BUYING ITEM \(error)") }
            }
        }
    }
    
    func hasItem(_ typeID: String) -> Bool {
        let found: Bool
        let item: String? = (self.player?.inventory?.items.first(where: { (key, value) in
            self.items[key]!.type.rawValue == typeID})?.value.id) ?? nil
                
        if item != nil {
            found = true
        } else {
            found = false
        }
        
        return found
    }
    
    
    func useFirstItemOfType(typeID: String) async {
        let userID = self.player!.id
        let item: String? = (self.player?.inventory?.items.first(where: { (key, value) in
            self.items[key]!.type.rawValue == typeID})?.value.id) ?? nil
        
        if item != nil{
            do {
                try await useItem(item!, userID: userID)
            } catch { print("Error using first item of type: \(error)") }
        }
    }
    
    
    func useItem(_ item: String, userID: String) async throws {
        ConnectionManager.shared.sendData(object: item) { _ in
            print("Use Item Error")
        }
        
        var invItem = self.player!.inventory!.getItem(item)
        let effectVal = self.items[item]!.effectValue ?? 0
        let type = self.items[item]!.type
                
        switch type{
        case .Food:
            self.player?.pet?.updateHunger(effectVal)
        case .Toy:
            self.player?.pet?.updateHappiness(effectVal)
        case .Hygiene:
            self.player?.pet?.updateHygiene(effectVal)
        case .Wearable:
            self.player?.pet?.updateEquipped(item)
        case .Test:
            print("TEST ITEM")
        case .none:
            print("MISSING ITEM TYPE")
        }
        
        if type != .Wearable{
            player?.inventory?.removeItem(item, userID: userID)
        }
        
        print("Used Item \(item)")
        
        do{
            invItem.quantity -= 1
            
            try await self.dbUtil.updateInventoryItem(invItem: invItem)
            try await self.dbUtil.updateInventory(userID: userID, inventory: self.player!.inventory!)
            try await self.dbUtil.updatePet(userID: userID, pet: self.player!.pet!)
        } catch {
            print("Error using item: \(error)")
        }
    }
    
    func login(username: String, password: String) async {
        let response = await authService.newUser(email: username, password: password)
        if case .success(let success) = response {
            guard let userID = authService.userID else { return }
            print("login success petviewmodel \(success)")
            await loggedIn(userID: userID, username: username)
        }
    }
        
        
    func loggedIn(userID: String, username: String) async {
        
        do{
            await initPlayer(userID: userID, username: username)
            print("Player initialized")
            
            self.petTypes = try await dbUtil.getPetTypes()
            guard self.petTypes.count > 0 else { return }
            print("Pet Types initialized")
            
            await initPet(userID: userID)
            print("Pet initialized")
            
            self.items = try await dbUtil.getItems()
            guard self.items.count > 0 else { return }
            print("Items initalized")
            
            await initInventory(userID: userID)
            guard self.player!.inventory != nil else { return }
            print("Inventory initialized")

            await initShop()
            print("Shop initialized")
            
            
        } catch {
            print("error after login \(error)")
        }
    }
    
    func initShop() async {
        do{
            let shop = try await dbUtil.getShop()
            if self.shop == nil {
                self.shop = shop
            }
        } catch DBError.notFound{
            
        } catch {
            print(error)
        }
    }
    
    
    func initInventory(userID: String) async {
        var inv: Inventory?
        do {
            inv = try await dbUtil.getInventory(userID: userID)
        } catch DBError.notFound{
            await dbUtil.addInventory(userID: userID)
            do{
                inv = try await dbUtil.getInventory(userID: userID)
            } catch {
                print("error getting after adding inv \(error)")
            }
        }catch { print("error getting inv \(error)")}
        
        guard inv != nil else { return }
        if self.player!.inventory == nil{
            self.player!.inventory = inv
        }
        
        
    }
    
    func initPlayer(userID: String, username: String) async {
        var play: Player?
        
        do{
            play = try await dbUtil.getPlayer(userID: userID)
        } catch DBError.notFound {
            await dbUtil.addPlayer(userID: userID, username: username)
            do{
                play = try await dbUtil.getPlayer(userID: userID)
            } catch { print("Error getting player: \(error)")}
        } catch { play = nil; print("Error getting player: \(error)")}
        
        guard play != nil else {return}
        if self.player == nil{
            self.player = play!
        }
        
    }

    
    func initPet(userID: String) async {
        do{
            let pet = try await dbUtil.getPet(userID: userID)
            
            if self.player?.pet == nil{
                self.player!.pet = pet
            }
            
            guard self.player?.pet != nil else { print("Error initializing pet");  return }
            await self.updatePetDecay()
        } catch {
            print(error)
        }
        
    }
    
    func startListeners(userID: String) async {
        await startPlayerListener(userID: userID)
        await startPetListener(userID: userID)
        await startInventoryListener(userID: userID)
        await startInventoryItemListener(userID: userID)
        await startShopListener()
        await startShopItemListener(id: self.shop!.id)
    }
    
    func startPlayerListener(userID: String) async{
        await self.dbUtil.listenToPlayer(userID: userID) { result in
            
            switch result {
            case .success(let player):
                Task { @MainActor in
                    if player.pet == nil && self.player?.pet != nil{
                        player.pet = self.player?.pet
                    }
                    
                    if player.inventory == nil && self.player?.inventory != nil{
                        player.inventory = self.player?.inventory
                    }
                    
                    self.player = player
                    print("PLAYER LISTENER FIRED")
                }
                
            case .failure(let error):
                print("PETMODELVIEW")
                print(error)
                
            }
        }
    }
    
    func startPetListener(userID: String) async {
        await self.dbUtil.listenToPet(userID: userID) { result in
            switch result {
            case .success(let petData):
                Task { @MainActor in
                    let updatedPlayer = self.player!
                    updatedPlayer.pet = petData
                    self.player = updatedPlayer
                }
                
                print("PET LISTENER FIRED")
            case .failure(let error):
                print("Pet Listener PetViewModel: \(error)")                
            }
        }
    }
    
    func startInventoryListener(userID: String) async {
       await self.dbUtil.listenToInventory(userID: userID) { result in
            switch result {
            case .success(let inventoryData):
                Task{ @MainActor in
                    if !self.player!.inventory!.items.isEmpty{
                        inventoryData.items = self.player!.inventory!.items
                    }
                    
                    self.player?.inventory = inventoryData
                }
                print("INVENTORY LISTENER FIRED")
            case .failure(let error):
                print("Inventory Listener PetViewModel: \(error)")

            }
        }
    }
    
    
    func startInventoryItemListener(userID: String) async {
       await self.dbUtil.listenToInventoryItems(userID: userID) { result in
            switch result {
            case .success(let inventoryItemData):
                Task { @MainActor in
                    let updatedPlayer = self.player!
                    updatedPlayer.inventory!.items[inventoryItemData.id] = inventoryItemData
                    self.player! = updatedPlayer
                }
                print("INVENTORY ITEM LISTENER FIRED \(String(describing: inventoryItemData))")
                
            case .failure(let error):
                print("Inventory Items Listener PetViewModel: \(error)")

            }
        }
    }
    
    
    func startShopListener() async {
       await self.dbUtil.listenToShop() { result in
            switch result {
            case .success(let shopData):
                Task { @MainActor in
                    shopData.items = self.shop!.items
                    
                    self.shop! = shopData
                }
                
                print("SHOP LISTENER FIRED")
            case .failure(let error):
                print("Shop Listener PetViewModel: \(error)")
                
            }
        }
    }

    func startShopItemListener(id: String) async {
        await self.dbUtil.listenToShopItems(shopID: id) { result in
            switch result {
            case .success(let shopItemData):
                Task { @MainActor in
                    self.shop!.items[shopItemData.id] = shopItemData
                }
                
                print("SHOP ITEM LISTENER FIRED")
            case .failure(let error):
                print("Shop Items Listener PetViewModel: \(error)")
                
            }
        }
    }
}

