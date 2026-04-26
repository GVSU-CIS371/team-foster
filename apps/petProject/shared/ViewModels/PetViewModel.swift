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
    let authService: AuthService
    private let connMan: ConnectionManager
    private var timeUnit = 1.0 // 60 = to Minutes, 1 = to Seconds
    private var decayInterval = 10 // timeUnits
    var logged: Bool = false
    var playerInit: Bool = false
    var petInit: Bool = false
    var itemInit: Bool = false
    var shopInit: Bool = false
    var inventoryInit: Bool = false
    var shopItemInit: Bool = false
    var invItemInit: Bool = false
    var ready: Bool = false
    var prevLogin: Bool = false
    
    private var userID: String {
        self.player?.id ?? ""
    }
    
    init(dbUtil: DBUtilities, authStatus: AuthService, cm: ConnectionManager = .shared){
        self.dbUtil = dbUtil
        self.authService = authStatus
        self.connMan = cm
        
        cm.onPlayerUpdate = { [weak self] player in
            Task{@MainActor in
                print("watch vm player update ", player)
                if player.pet == nil {
                    player.pet = self?.player?.pet
                }
                
                if player.inventory == nil {
                    player.inventory = self?.player?.inventory
                }
                
                self?.player = player as Player
                
                print(self?.player ?? "no player", self?.player?.pet ?? "no pet", self?.player?.inventory ?? "no inventory")
                self?.logged = true
                self?.playerInit = true
                self?.CheckReady()
                print("player updated watch ", self?.player ?? "nil")
                print("updated from ", player)
            }
        }
        cm.onPetUpdate = { [weak self] pet in
            Task{@MainActor in
                
                print("watch vm pet update ", pet)

                
                let player = self?.player
                
                player?.pet = pet as Pet?
                
                self?.player = player
                self?.petInit = true
                
                self?.CheckReady()
            }
        }
        cm.onInventoryUpdate = { [weak self] inv in
            Task{@MainActor in
                
                print("watch vm inventory update ", inv)

                print("RECEIVED INVENTORY")
                if self?.player?.inventory != nil && inv.items.isEmpty {
                    inv.items = self?.player?.inventory?.items ?? ["error":InventoryItem(id: "error", quantity: -1, userID: "error")]
                }
                self?.player?.inventory = inv as Inventory
                self?.inventoryInit = true
                
                Task{ @MainActor in
                    try await dbUtil.getInventoryItems(userID: self!.userID)
                }
                
                self?.CheckReady()
            }
        }
        cm.onInvItemUpdate = { [weak self] invItem in
            Task{@MainActor in
                
                print("watch vm inventory item update ", invItem)

                if(invItem.id != "empty"){
                    
                    guard let player = self?.player else {return}
                    player.inventory?.items[invItem.id] = invItem as InventoryItem
                    self?.player = player
                }
                self?.invItemInit = true

                self?.CheckReady()
            }
        }
        cm.onShopUpdate = { [weak self] shop in
            Task{@MainActor in
                
                print("watch vm shop update ", shop)
 
                if shop.items.isEmpty {
                    shop.items = self?.shop?.items ?? [:]
                }
                self?.shop = shop as Shop
                self?.shopInit = true
                
                Task{@MainActor in
                    try await dbUtil.getShopItems(name: self!.shop!.id)
                }
                
                self?.CheckReady()
            }
        }
        cm.onShopItemUpdate = { [weak self] shopItem in
            Task{@MainActor in
                
                print("watch vm shop item update ", shopItem)

                guard let shop = self?.shop else {return}
                shop.items[shopItem.id] = shopItem as ShopItem
                self?.shop = shop
                self?.shopItemInit = true
                
                
                self?.CheckReady()
            }
        }
        
        print("PVM INIT ", ObjectIdentifier(self))
        print(authService.userID ?? "no user")
    }
    
    func petTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true){ _ in
            
            Task{ @MainActor in
                await self.updatePetDecay()
            }
        }
    }
    
    func updatePetDecay() async {
        guard self.player != nil else {
            print("MISSING PLAYER UPDATE PET DECAY")
            return }
        guard self.player?.pet != nil else {
            print("MISSING PET UPDATE PET DECAY")
            return }
        print("PLAYER AND PET OK UPDATE PET DECAY")
        
        let lastPetUpdated = self.player?.pet?.lastUpdate ?? nil
        let timeSincePetUpdate = Date().timeIntervalSince(lastPetUpdated!) / timeUnit
        let intervalsSincePetUpdate = Int(floor(timeSincePetUpdate / Double(self.decayInterval)))
        
        guard intervalsSincePetUpdate > 0 else {return}
        let typeID = self.player!.pet!.typeID
        
        self.player?.currency += 100 * intervalsSincePetUpdate
        self.player?.pet?.decayPetStats(type: self.petTypes[typeID]!, intervals: 1)

        do{
            print("BEFORE UPDATE PLAYER")
            try await self.dbUtil.updatePlayer(userID: self.player!.id, player: self.player!)
            print("AFTER UPDATE PLAYER BEFORE UPDATE PET")
            try await self.dbUtil.updatePet(userID: self.player!.id, pet: self.player!.pet!)
            print("UPDATE PET")
        } catch {
            print("Error updating pet decay")
        }
    }
    
    func CheckReady(){
        print("CHECK READY", playerInit, petInit, shopInit, inventoryInit, invItemInit, shopItemInit)
        
        if(playerInit && petInit && shopInit && inventoryInit && shopItemInit) {
            Task{@MainActor in
                self.ready = true
            }
            
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
        print("FIRST TYPE", typeID)
        let userID = self.player!.id
        let item: String? = (self.player?.inventory?.items.first(where: { (key, value) in
            self.items[key]!.type.rawValue == typeID})?.value.id) ?? nil
        
        print("FIRST ITEM", item ?? "no item")
        
        if item != nil{
            do {
                print("USE ITEM", item ?? "no item", userID)
                try await useItem(item!, userID: userID)
            } catch { print("Error using first item of type: \(error)") }
        }
    }
    
    
    func useItem(_ item: String, userID: String) async throws {
        
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
            
            print("USE ITEM UPDATERS")
            print("++++++++++++++++++++++++ UPDATE INVENTORY ITEM")
            try await self.dbUtil.updateInventoryItem(invItem: invItem)
            print("++++++++++++++++++++++++ UPDATE INVENTORY")
            try await self.dbUtil.updateInventory(userID: userID, inventory: self.player!.inventory!)
            print("++++++++++++++++++++++++ UPDATE PET")
            try await self.dbUtil.updatePet(userID: userID, pet: self.player!.pet!)
        } catch {
            print("Error using item: \(error)")
        }
    }
    
    func login(username: String, password: String) async {
        guard !username.isEmpty, !password.isEmpty else {
            print("empty username or password")
            return }
        let response = await authService.newUser(email: username + "@test.com", password: password)
        print(response)
        switch response {
            
        case .success(let success):
            print("user logged in ", success)
            guard let userID = authService.userID else {
                print("no auth service user id")
                return }
            print("login success petviewmodel \(success)")
            await loggedIn(userID: userID, username: username)
        case.failure(let error):
            print("login error:", error.localizedDescription)
        }
    }
        
        
    func loggedIn(userID: String, username: String) async {
        
        do{
            print("LOGGED IN START player:", self.player?.id ?? "nil")
            if username != ""{
                print(username)
                await initPlayer(userID: userID, username: username)
                print("Player initialized")
            } else if userID != "" {
                self.player = try await dbUtil.getPlayer(userID: userID)
            }
            self.petTypes = try await dbUtil.getPetTypes()
            guard self.petTypes.count > 0 else { return }
            print("Pet Types initialized")
            print(self.petTypes)
            await initPet(userID: userID)
            print("Pet initialized")
            self.items = try await dbUtil.getItems()
            guard self.items.count > 0 else { return }
            print("Items initalized")
            print(self.items)
            await initInventory(userID: userID)
            guard self.player!.inventory != nil else { return }
            print("Inventory initialized")
            await initShop()
            print("Shop initialized")
            
            
        } catch {
            print("error after login \(error)")
        }
    }
    
    func logout() async{
        Task{@MainActor in
            print("VM LOGOUT TASK")
            
            self.player = nil
            self.ready = false
            self.playerInit = false
            self.petInit = false
            self.shopInit = false
            self.inventoryInit = false
            self.invItemInit = false
            self.shopItemInit = false
            self.logged = false
            self.prevLogin = true
            self.dbUtil.stopListening()
            await self.authService.logout()
            
            
            print(self.player ?? "no player")
            print(self.authService.userID ?? "no userID")
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
            print("initPlayer play ", play ?? "no player")
        } catch DBError.notFound {
            print(username)
            await dbUtil.addPlayer(userID: userID, username: username)
            do{
                play = try await dbUtil.getPlayer(userID: userID)
                print("initPlayer play retry ", play ?? "no player")

            } catch { print("Error getting player: \(error)")}
        } catch { play = nil; print("Error getting player: \(error)")}
        
        guard play != nil else {return}
        if self.player == nil{
            self.player = play!
            print("initial player")
        }
        
    }

    
    func initPet(userID: String) async {
        do{
            let pet = try await dbUtil.getPet(userID: userID)
            dump(pet)
            print("RECEIVED PET")
            dump(self.player?.pet)
            print("PLAYER PET")
            
            self.player?.pet = pet
            
            if self.player?.pet!.id == "error"{
                print("ERROR PET")
                self.player?.pet = nil
            }
            
            print("PLAYER PET STATUS", self.player?.pet ?? "no pet")
            guard self.player?.pet != nil else { print("Error initializing pet");  return }
            await self.updatePetDecay()
        } catch {
            print("INIT PET ERROR", error)
        }
        
    }
    
    func startListeners(userID: String) async {
        if(userID != ""){
            await startPlayerListener(userID: userID)
            await startPetListener(userID: userID)
            await startInventoryListener(userID: userID)
            await startInventoryItemListener(userID: userID)
            await startShopListener()
            await startShopItemListener(id: self.shop!.id)
        }
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
                
            case .failure(let error):
                print("Shop Items Listener PetViewModel: \(error)")
                
            }
        }
    }
}

