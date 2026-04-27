//
//  DBUtilitiesWatch.swift
//  petProject
//
//  Created by Aaron Foster on 4/2/26.
//

//
//  DBListeners.swift
//  petProject
//
//  Created by Aaron Foster on 4/2/26.
//

import SwiftUI

class DBUtilitiesWatch: DBUtilities {
    func stopListening() {
        print("STOP LISTENING")
    }
    
    
    private let cm: ConnectionManager
    

    
    init(cm: ConnectionManager = .shared){
        self.cm = cm
        
        cm.registerData(type: Player.self){data, action, reply  in
            print("Player")
            let userID = data.id
            let username = data.username
            
            switch action {
            case .get:
                Task{@MainActor in
                    do{
                        let player = try await self.getPlayer(userID: userID)
                        print("watch get player ", player)
                        reply(player)
                    } catch(let error) {
                        print(error)
                    }
                }
            case .add:
                Task{@MainActor in

                    do{
                        await self.addPlayer(userID: userID, username: username)

                        let player = try await self.getPlayer(userID: userID)
                        print("watch add player ", player)
                        reply(player)
                    } catch(let error) {
                        print(error)
                    }
                }
            case .update:
                Task{@MainActor in
                    cm.onPlayerUpdate?(data)
                    print("dbutilitieswatch watch update player", data)
                    reply(data)
                }
            default:
                break
            }
        }
        cm.registerData(type: Pet.self){data, action, reply in
            print("Pet")
            switch action {
            case .get:
                Task{@MainActor in
                    do{
                        let pet = try await self.getPet(userID: data.id!)
                        print("watch get pet ", pet)
                        reply(pet)
                    } catch(let error) {
                        print(error)
                    }
                }
            case .add:
                Task{@MainActor in
                    do{
                        await self.addPet(userID: data.id!, name: data.name, typeID: data.typeID)
                        let pet = try await self.getPet(userID: data.id!)
                        print("watch add pet ", pet)
                        reply(pet)
                    } catch(let error) {
                        print(error)
                    }
                }
                
            case .update:
                Task{@MainActor in
                    cm.onPetUpdate?(data)
                    print("dbutilitieswatch watch update pet", data)
                    reply(data)
                }
            default:
                break
            }
        }
        cm.registerData(type: Inventory.self){data, action, reply in
            print("Inventory")
            switch action {
            case .get:
                Task{@MainActor in
                    let inventory = try await self.getInventory(userID: data.id)
                    print("watch get inventory ", inventory)
                    reply(inventory)
                }
            case .add:
                Task{@MainActor in
                    do{
                        await self.addInventory(userID: data.id)
                        let inventory = try await self.getInventory(userID: data.id)
                        print("watch add inventory ", inventory)
                        reply(inventory)
                    } catch(let error) {
                        print(error)
                    }
                }
            case .update:
                Task{@MainActor in
                    cm.onInventoryUpdate?(data)
                    print("dbutilitieswatch watch update inventory", data)
                    reply(data)
                }
                
            default:
                break
            }
        }
        cm.registerData(type: Shop.self){data, action, reply in
             print("Shop")
            switch action {
            case .get:
                Task{@MainActor in
                    do{
                        let shop = try await self.getShop()
                        print("watch get shop ", shop)
                        reply(shop)
                    } catch(let error) {
                        print(error)
                    }
                }
            case .add:
                Task{@MainActor in
                    do{
                        await self.addShop(name: data.name)
                        let shop = try await self.getShop()
                        print("watch add shop ", shop)
                        reply(shop)
                    } catch(let error) {
                        print(error)
                    }
                }
                
            case .update:
                Task{@MainActor in
                    cm.onShopUpdate?(data)
                    print("dbutilitieswatch watch update shop", data)
                    reply(data)
                }
            default:
                break
            }
        }
        cm.registerData(type: ShopItem.self){data, action, reply in
            print("ShopItem")
            switch action {
            case .get:
                Task{@MainActor in
                    do{
                        let listOfItems = try await self.getShopItems(name: data.shopID)
                        let shopItem = listOfItems[data.id]!
                        print("watch get shopItems ", shopItem)
                        reply(shopItem)
                    } catch(let error) {
                        print(error)
                    }
                }
                
            case .update:
                Task{@MainActor in
                    cm.onShopItemUpdate?(data)
                    print("watch update shopItem", data)
                    reply(data)

                }
            default:
                break
            }
        }
        cm.registerData(type: InventoryItem.self){data, action, reply in
            print("InventoryItem")
            switch action {
            case .get:
                Task{@MainActor in
                    {
                        do {
                            let listOfItems = try await self.getInventoryItems(userID: data.id )
                            let inventoryItem = listOfItems[data.id]!
                            print("watch get inventoryItems ", inventoryItem)
                            reply(inventoryItem)
                        } catch(let error) {
                            print(error)
                        }
                    }
                }
            case .update:
                Task{@MainActor in
                    cm.onInvItemUpdate?(data)
                    print("watch update invItem", data)
                    reply(data)
                }
            default:
                break
            }
        }
        cm.registerData(type: [String:Item].self) {data, action, reply in
            print("Items")
            switch action {
            case .get:
                Task{@MainActor in
                    do{
                        let items = try await self.getItems()
                        print("watch get items ", items)
                        reply(items)
                    } catch(let error) {
                        print(error)
                    }
                }
           
            default:
                break
            }
        }
        cm.registerData(type: [String: PetType].self) {data, action, reply in
            print("PetTypes")
            switch action {
            case .get:
                Task{@MainActor in
                    do{
                        let petTypes = try await self.getPetTypes()
                        print("watch get pet types ", petTypes) 
                        reply(petTypes)
                    } catch(let error) {
                        print(error)
                    }
                }
            
            default:
                break
            }
        }
    }
    
    func listenToInventoryItems(userID: String, listened: @escaping (Result<InventoryItem, any Error>) -> Void) async {
        print("Listen to Inventory Items Watch")
    }
    
    
    func listenToShopItems(shopID: String, listened: @escaping (Result<ShopItem, any Error>) -> Void) async {
        print("Listen to Shop Items Watch")
    }
    
    
    
    
    func encode<T: Codable>(data: T) throws -> [String : Any]{
        print("ENCODE")
        return [:]
    }
    
    func updateInventoryItem(invItem: InventoryItem) async throws {
        print("UPDATE INVENTORY ITEM Watch")
        self.cm.sendData(data: invItem, action: ConnectionManager.ActionType.update){ reply in
            guard !reply.isEmpty else {
                print("no data inventory items")
                return
            }
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {
                print("cant decode to encoded message")
                return
            }
            guard let invItemData = try? JSONDecoder().decode([String: InventoryItem].self, from: response.payload) else {
                print("error getting inventory item data ------------------------------")
                //continuation.resume(throwing: AuthStatus.failure)
                return
            }
            print(" getting inventory item data++++++++++++++++++++++++++++++++++++++")
            print(invItemData)
            invItemData.forEach { invItem in
                print(invItem)
                self.cm.onInvItemUpdate?(invItem.value)
            }
            //continuation.resume(returning: invItemData)
        }
    }
    
    func updateShopItem(shopItem: ShopItem) async throws {
        print("UPDATE SHOP ITEM Watch")
        self.cm.sendData(data: shopItem, action: ConnectionManager.ActionType.update){ reply in
            guard !reply.isEmpty else {
                print("no data inventory items")
                return
            }
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {
                print("cant decode to encoded message")
                return
            }
            guard let shopItemData = try? JSONDecoder().decode([String: ShopItem].self, from: response.payload) else {
                print("error getting shop item data ------------------------------")
                //continuation.resume(throwing: AuthStatus.failure)
                return
            }
            print(" getting shop item data++++++++++++++++++++++++++++++++++++++")
            print(shopItemData)
            shopItemData.forEach { shopItem in
                print(shopItem)
                self.cm.onShopItemUpdate?(shopItem.value)
            }
            //continuation.resume(returning: invItemData)
        }
        
        //cm.onShopItemUpdate?(shopItem)
    }
    

    
    func updatePlayer(userID: String, player: Player) async throws {
        print("UPDATE PLAYER")
        self.cm.sendData(data: player, action: ConnectionManager.ActionType.update){ reply in
            guard !reply.isEmpty else {
                print("no player data")
                return
            }
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {
                print("cant decode to encoded message")
                return
            }
            guard let playerData = try? JSONDecoder().decode(Player.self, from: response.payload) else {
                print("error getting player data ------------------------------")
                //continuation.resume(throwing: AuthStatus.failure)
                return
            }
            print(" getting player data++++++++++++++++++++++++++++++++++++++")
            print(playerData)
     
            self.cm.onPlayerUpdate?(playerData)
            
            //continuation.resume(returning: invItemData)
        }
        
        //cm.onPlayerUpdate?(player)
        print("watch update player ", String(player.id))
    }
    
    func updatePet(userID: String, pet: Pet) async throws {
        print("UPDATE PET")
        self.cm.sendData(data: pet, action: ConnectionManager.ActionType.update){ reply in
            guard !reply.isEmpty else {
                print("no data pet")
                return
            }
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {
                print("cant decode to encoded message")
                return
            }
            guard let petData = try? JSONDecoder().decode(Pet.self, from: response.payload) else {
                print("error getting pet data ------------------------------")
                //continuation.resume(throwing: AuthStatus.failure)
                return
            }
            print(" getting pet data++++++++++++++++++++++++++++++++++++++")
            print(petData)
     
            self.cm.onPetUpdate?(petData)
            
            //continuation.resume(returning: invItemData)
        }
        
    }
    
    func updateInventory(userID: String, inventory: Inventory) async throws {
        print("UPDATE INVENTORY")
        self.cm.sendData(data: inventory, action: ConnectionManager.ActionType.update){ reply in
            guard !reply.isEmpty else {
                print("no data inventory")
                return
            }
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {
                print("cant decode to encoded message")
                return
            }
            guard let inventoryData = try? JSONDecoder().decode(Inventory.self, from: response.payload) else {
                print("error getting inventory data ------------------------------")
                //continuation.resume(throwing: AuthStatus.failure)
                return
            }
            print(" getting inventory data++++++++++++++++++++++++++++++++++++++")
            print(inventoryData)
     
            self.cm.onInventoryUpdate?(inventoryData)
            
            //continuation.resume(returning: invItemData)
        }
        
        //cm.onInventoryUpdate?(inventory)
    }
    
    func updateShop(shopID: String, shop: Shop) async throws {
        print("UPDATE SHOP")
        
        self.cm.sendData(data: shop, action: ConnectionManager.ActionType.update){ reply in
            guard !reply.isEmpty else {
                print("no shop pet")
                return
            }
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {
                print("cant decode to encoded message")
                return
            }
            guard let shopData = try? JSONDecoder().decode(Shop.self, from: response.payload) else {
                print("error getting shop data ------------------------------")
                //continuation.resume(throwing: AuthStatus.failure)
                return
            }
            print(" getting shop data++++++++++++++++++++++++++++++++++++++")
            print(shopData)
     
            self.cm.onShopUpdate?(shopData)
            
            //continuation.resume(returning: invItemData)
        }
        //cm.onShopUpdate?(shop)
    }
    
    func getInventoryItems(userID: String) async throws -> [String : InventoryItem] {
        print("get Inventory Items Watch")
        let item = InventoryItem(id: "test", quantity: -1, userID: userID)
        let data = [item.id: item] as [String: InventoryItem]
        print(data)
        return try await withCheckedThrowingContinuation { continuation in
            
        
            self.cm.sendData(data: data, action: ConnectionManager.ActionType.get){ reply in
                guard !reply.isEmpty else {
                    print("no data inventory items")
                    return
                }
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {
                    print("cant decode to encoded message")
                    return
                }
                guard let invItemData = try? JSONDecoder().decode([String: InventoryItem].self, from: response.payload) else {
                    print("error getting inventory item data ------------------------------")
                    continuation.resume(throwing: AuthStatus.failure)
                    return
                }
                print(" getting inventory item data++++++++++++++++++++++++++++++++++++++")
                print(invItemData)
                invItemData.forEach { invItem in
                    self.cm.onInvItemUpdate?(invItem.value)
                }
                
                if invItemData.isEmpty {
                    self.cm.onInvItemUpdate?(InventoryItem(id:"empty", quantity: -1, userID: userID))
                }
                
                continuation.resume(returning: invItemData)
            }
        }
    }
    
    func getShopItems(name: String) async throws -> [String : ShopItem] {
        print("get Shop Items Watch")
        let item = ShopItem(shopID: name)
        let data = [item.id: item] as [String: ShopItem]
        print(data)
        return try await withCheckedThrowingContinuation { continuation in
            
        
            self.cm.sendData(data: data, action: ConnectionManager.ActionType.get){ reply in
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let shopItemData = try? JSONDecoder().decode([String: ShopItem].self, from: response.payload) else {
                    print("error getting shop item data")
                    continuation.resume(throwing: AuthStatus.failure)
                    return
                }
                print(" getting shop item data")
                print(shopItemData)
                
                shopItemData.forEach { shopItem in
                    self.cm.onShopItemUpdate?(shopItem.value)
                }
                

                continuation.resume(returning: shopItemData)
            }
        }
    }
    
    func getItems() async throws -> [String : Item] {
        print("GET ITEMS WATCH")
        let item = Item()
        let data = [item.name: item] as [String: Item]
        
        return try await withCheckedThrowingContinuation { continuation in
            
        
            self.cm.sendData(data: data, action: ConnectionManager.ActionType.get){ reply in
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let itemData = try? JSONDecoder().decode([String: Item].self, from: response.payload) else {
                    print("error getting item data")
                    continuation.resume(throwing: AuthStatus.failure)
                    return
                }
                print(" getting player data")
                
                continuation.resume(returning: itemData)
            }
        }
    }
    
    func getPetTypes() async throws -> [String : PetType] {
        print("GET PET TYPES")
        return try await withCheckedThrowingContinuation { continuation in
            self.cm.sendData(data: [:] as [String: PetType], action: ConnectionManager.ActionType.get){ reply in
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let petTypeData = try? JSONDecoder().decode([String: PetType].self, from: response.payload) else {
                    print("error getting pet type data")
                    continuation.resume(throwing: AuthStatus.failure)
                    return
                }
                print(" getting player data")

                continuation.resume(returning: petTypeData)
            }
        }
    }
    
    func getPlayer(userID: String) async throws -> Player {
        print("WATCH GET PLAYER")
        let pData = Player(id: userID)
        
        return try await withCheckedThrowingContinuation { continuation in
            
            self.cm.sendData(data: pData, action: ConnectionManager.ActionType.get){ reply in
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let playerData = try? JSONDecoder().decode(Player.self, from: response.payload) else {
                    print("error getting player data")
                    continuation.resume(throwing: AuthStatus.failure)
                    return
                }
                print(" getting player data")
                self.cm.onPlayerUpdate?(playerData)
                continuation.resume(returning: playerData)
            }
        }
    }
    
    func getPet(userID: String) async throws -> Pet {
        print("WATCH GET PET")
        let data = Pet(id: userID)
        
        return try await withCheckedThrowingContinuation { continuation in
            
            self.cm.sendData(data: data, action: ConnectionManager.ActionType.get){ reply in
                
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let petData = try? JSONDecoder().decode(Pet.self, from: response.payload) else {
                    print("error getting pet data")
                    continuation.resume(throwing: AuthStatus.failure)
                    return
                }
                print(" getting pet data")
                
                
                self.cm.onPetUpdate?(petData)
                continuation.resume(returning: petData)
            }
        }
    }
    
    func getInventory(userID: String) async throws -> Inventory {
        print("WATCH GET INVENTORY")
        let data = Player(id: userID)
        
        return try await withCheckedThrowingContinuation { continuation in
        
            self.cm.sendData(data: data, action: ConnectionManager.ActionType.get){ reply in
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let invData = try? JSONDecoder().decode(Inventory.self, from: response.payload) else {
                    print("error getting inventory data")
                    continuation.resume(throwing: AuthStatus.failure)
                    return
                }
                print(" getting player data")
                self.cm.onInventoryUpdate?(invData)
                continuation.resume(returning: invData)
            }
        }
    }
    
    func getShop() async throws -> Shop {
        let data = Shop()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.cm.sendData(data: data, action: ConnectionManager.ActionType.get){ reply in
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let shopData = try? JSONDecoder().decode(Shop.self, from: response.payload) else {
                    print("error getting shop data")
                    continuation.resume(throwing: AuthStatus.failure)
                    return
                }
                print("returned shop data ", shopData.id)
                self.cm.onShopUpdate?(shopData)
                continuation.resume(returning: shopData)
            }
        }
    }
    
    
    func addPet(userID: String, name: String, typeID: String) async {
        print("WATCH ADD PET")
        let pet = Pet(id: userID, name: name, typeID: typeID)
        
        self.cm.sendData(data: pet, action:ConnectionManager.ActionType.add) { reply in
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {return}
            guard let petData = try? JSONDecoder().decode(Pet.self, from: response.payload) else {return}
            print("returned pet data ", petData.self)
            if(petData.id != pet.id!){
                print("ERROR ADDING PET")
            }
                  
        }
    }
    
    func addInventory(userID: String) async {
        print("WATCH ADD INVENTORY")
    }
    
    func addShop(name: String) async {
        print("WATCH ADD SHOP")
    }
    
    
    func showError(error: any Error) -> DBError {
        print("SHOW ERROR")
        return DBError.unknownError
    }
    
    func listenToPlayer(userID: String, listened: @escaping (Result<Player, any Error>) -> Void) {
        print("WATCH LISTEN TO PLAYER")
    }
    
    func addPlayer(userID: String, username: String) async {
        print("ADD PLAYER WATCH")
        let player = Player(id: userID, username: username)
        
        self.cm.sendData(data: player, action:ConnectionManager.ActionType.add) { reply in
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {return}
            guard let playerData = try? JSONDecoder().decode(Player.self, from: response.payload) else {return}
            print("returned player data ", playerData.id)
            if(playerData.id != player.id){
                print("ERROR ADDING PLAYER")
            }
        }
        
    }
    
    func listenToPet(userID: String, listened: @escaping (Result<Pet, any Error>) -> Void){
        print("WATCH LISTEN TO PET")
    }
    func listenToInventory(userID: String, listened: @escaping (Result<Inventory, any Error>) -> Void) {
        print("WATCH LISTEN TO INVENTORY")
    }
    func listenToShop(listened: @escaping (Result<Shop, any Error>) -> Void) {
        print("WATCH LISTEN TO SHOPS")
    }
    

}
