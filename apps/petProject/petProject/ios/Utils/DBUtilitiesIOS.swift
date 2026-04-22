//
//  DbListenersIOS.swift
//  petProject
//
//  Created by Aaron Foster on 4/2/26.
//
import FirebaseFirestore

extension DBError {
    init(error: Error) {
        let nsError = error as NSError
        let fireError = FirestoreErrorCode.Code(rawValue: nsError.code)
        switch fireError{
        case .notFound:
            self = DBError.notFound
        default:
            self = DBError.unknownError
        }
    }
}

class DBUtilitiesIOS: DBUtilities {
    
    private var cm: ConnectionManager
    private var listeners: [ListenerRegistration] = []

    
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
                        
                        reply(player)
                    } catch(let error) {
                        print("failed ", error)
                        
                        switch error as? DBError {
                        case .notFound:
                            await self.addPlayer(userID: userID, username: username)
                            let player = try await self.getPlayer(userID: userID)
                            reply(player)
                            
                        default:
                            break
                        }
                    }
                }
            case .add:
                Task{@MainActor in

                    do{
                        await self.addPlayer(userID: userID, username: username)

                        let player = try await self.getPlayer(userID: userID)
                        
                        reply(player)
                    } catch(let error) {
                        print(error)
                    }
                }
            case .update:
                Task{@MainActor in
                    do{
                        print("UPDATE PLAYER ON WATCH FROM PHONE")
                        try await self.updatePlayer(userID: userID, player: data)
                        
                        reply(data)
                        
                    } catch(let error) {
                        print(error)
                    }
                }
            default:
                break
            }
        }
        cm.registerData(type: Pet.self){data, action, reply in
            print("Pet")
            switch action {
            case .get:
                Task {@MainActor in
                    do{
                        let pet = try await self.getPet(userID: data.id!)
                        reply(pet)
                    } catch (let error){
                        print("ERROR GETTING PET FOR WATCH", error)
                        let errorPet = Pet(id: "error")
                        print("ERROR PET", errorPet)
                        reply(errorPet)
                    }
                }
            case .add:
                Task{@MainActor in
                    do{
                        await self.addPet(userID: data.id!, name: data.name, typeID: data.typeID)
                        let pet = try await self.getPet(userID: data.id!)
                        reply(pet)
                    } catch(let error) {
                        print(error)
                        let errorPet = Pet(id: "error")
                        print("ERROR PET", errorPet)
                        reply(errorPet)
                    }
                }
                
            case .update:
                Task{@MainActor in
                    do{
                        print("UPDATE PET ON WATCH FROM PHONE")
                        try await self.updatePet(userID: data.id!, pet: data)
                        reply (data)
                    } catch(let error){
                        print(error)
                    }
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
                    reply(inventory)
                }
            case .add:
                Task{@MainActor in
                    do{
                        await self.addInventory(userID: data.id)
                        let inventory = try await self.getInventory(userID: data.id)
                        reply(inventory)
                    } catch(let error) {
                        print(error)
                    }
                }
            case .update:
                Task{@MainActor in
                    do{
                        try await self.updateInventory(userID: data.id, inventory: data)
                    } catch(let error){
                        print(error)
                    }
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
                        print(shop)
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
                        print(shop)
                        reply(shop)
                    } catch(let error) {
                        print(error)
                    }
                }
                
            case .update:
                Task{@MainActor in
                    do{
                        try await self.updateShop(shopID: data.id, shop: data)
                        reply(data)
                    } catch(let error) {
                        print(error)
                    }
                }
            default:
                break
            }
        }
        cm.registerData(type: [String:ShopItem].self){data, action, reply in
            print("ShopItem")
            switch action {
            case .get:
                Task{@MainActor in
                    do{
                        let shopItems = try await self.getShopItems(name: data.values.first!.shopID)
                        reply(shopItems)
                    } catch(let error) {
                        print(error)
                    }
                }
                
            case .update:
                Task{@MainActor in
                    do{
                        try await self.updateShopItem(shopItem: data.values.first!)
                        reply(data)
                    } catch(let error) {
                        print(error)
                    }
                }
            default:
                break
            }
        }
        cm.registerData(type: [String:InventoryItem].self) { data, action, reply in
            print("Inventory Items")
            switch action{
            case .get:
                Task{@MainActor in
                    do{
                        let inventoryItems = try await self.getInventoryItems(userID: data.values.first!.userID)
                        
                        reply(inventoryItems)
                    } catch (let error) {
                        print(error)
                    }
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
                    
                        do {
                            let listOfItems = try await self.getInventoryItems(userID: data.userID)
                            let inventoryItem = listOfItems[data.id]!
                            reply(inventoryItem)
                        } catch(let error) {
                            print(error)
                        }
                    
                }
            case .update:
                Task{@MainActor in
                    do{
                        try await self.updateInventoryItem(invItem: data)
                        reply(data)
                    } catch(let error) {
                        print(error)
                    }
                }
            default:
                break
            }
        }
        cm.registerData(type: [String:Item].self) {data, action, reply in
            print("Item")
            switch action {
            case .get:
                Task{@MainActor in
                    do{
                        let items = try await self.getItems()
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
    
    func getItems() async throws -> [String : Item] {
        let collectName = CollectionNames.items.rawValue
        
        let result: Result<[Item], Error> = await DBService.shared.readCollection(collectName: collectName)
        
        var items: [String:Item] = [:]
        
        switch result {
        case .success(let itemData):
            itemData.forEach { item in
                items[item.id] = item
            }
        case .failure(let error):
            print("Failed to get pet types \(error)")
            throw error
        }
        
        return items
    }
    
    func encode<T: Codable>( data: T) throws -> [String: Any] {
        do{
            let json = try JSONEncoder().encode(data)
            let encoded = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] ?? [:]
            
            return encoded
        } catch {
            throw error
        }
    }
    
    
    func updatePlayer(userID: String, player: Player) async throws{
        print("UPDATE PLAYER")
        let collectName = CollectionNames.users.rawValue
        player.lastUpdate = Date()
        await DBService.shared.updateNamedDoc(collectName: collectName, docName: userID, data: player)
        
        //return try await withCheckedThrowingContinuation{ continuation in
            //print("SENDING TO WATCH")
            cm.sendData(data: player, action: .update){ reply in
                print("update player")
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let decoded = try? JSONDecoder().decode(Player.self, from: response.payload) else {
                    print("problem updating watch of player changes")
                    return }
                print(decoded)
                //continuation.resume(returning: ())
            }
        //}
    }
    
    func updatePet(userID: String, pet:Pet) async throws {
        let collectName = CollectionNames.pets.rawValue
        pet.lastUpdate = Date()
        await DBService.shared.updateNamedDoc(collectName: collectName, docName: userID, data: pet)
        
        cm.sendData(data: pet, action: .update){ reply in
            print("update pet")
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                  let decoded = try? JSONDecoder().decode(Pet.self, from: response.payload) else {
                print("problem updating watch of pet changes")
                return }
            print(decoded)
            //continuation.resume(returning: ())
        }
    }
    
    func updateInventory(userID: String, inventory: Inventory) async throws{
        let collectName = CollectionNames.inventories.rawValue
        inventory.lastUpdate = Date()
        await DBService.shared.updateNamedDoc(collectName: collectName, docName: userID, data: inventory)
        
        cm.sendData(data: inventory, action: .update){ reply in
            print("update inventory")
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                  let decoded = try? JSONDecoder().decode(Inventory.self, from: response.payload) else {
                print("problem updating watch of inventory changes")
                return }
            print(decoded)
            //continuation.resume(returning: ())
        }
    }
    
    func updateInventoryItem(invItem: InventoryItem) async throws{
        let filters = [Filter(from: "user_id", to: invItem.userID, op: FilterOperation.EqualTo), Filter(from: "item_id", to: invItem.id, op: FilterOperation.EqualTo)]
        let collectName = CollectionNames.inventory_items.rawValue
        
        if invItem.quantity > 0 {
            await DBService.shared.updateDoc(collectName: collectName, data: invItem, filters: filters)
            
            cm.sendData(data: invItem, action: .update){ reply in
                print("update inventory item")
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                      let decoded = try? JSONDecoder().decode(InventoryItem.self, from: response.payload) else {
                    print("problem updating watch of inventory item changes")
                    return }
                print(decoded)
                //continuation.resume(returning: ())
            }
        } else {
            await DBService.shared.deleteDoc(collectName: collectName, filters: filters)
        }
    }
    
    func updateShop(shopID: String, shop: Shop) async throws {
        let filters = Filter(from: "shop_id", to: shopID, op: FilterOperation.EqualTo)
        let collectName = CollectionNames.shops.rawValue
        shop.lastUpdate = Date()
        await DBService.shared.updateDoc(collectName: collectName, data: shop, filters: [filters])
        
        cm.sendData(data: shopID, action: .update){ reply in
            print("update shop")
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                  let decoded = try? JSONDecoder().decode(Shop.self, from: response.payload) else {
                print("problem updating watch of shop changes")
                return }
            print(decoded)
            //continuation.resume(returning: ())
        }
    }
    
    func updateShopItem(shopItem: ShopItem) async throws{
        let filters = [Filter(from: "shop_id", to: shopItem.shopID, op: FilterOperation.EqualTo), Filter(from: "item_id", to: shopItem.id, op: FilterOperation.EqualTo)]
        let collectName = CollectionNames.shop_items.rawValue
        await DBService.shared.updateDoc(collectName: collectName, data: shopItem, filters: filters)
        
        cm.sendData(data: shopItem, action: .update){ reply in
            print("update player")
            guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply),
                  let decoded = try? JSONDecoder().decode(ShopItem.self, from: response.payload) else {
                print("problem updating watch of player changes")
                return }
            print(decoded)
            //continuation.resume(returning: ())
        }
    }
    
    func updateFields(collectName: String, userID: String, fields: [String:Any]) async {
        //await DBService.shared.updateDoc(collectName: collectName, data: fields)
    }
    
    
    
    func getPlayer(userID: String) async throws -> Player {
        let collectName = CollectionNames.users.rawValue
        let playerFilter = Filter(from: "user_id", to: userID, op: FilterOperation.EqualTo)
        
        let result: Result<Player, Error> = await DBService.shared.readNamedDoc(collectName: collectName, docName: userID, filters: [playerFilter])
        let player: Player
        
        switch result {
        case .success(let playerData):
            player = playerData
            print(player)
        case .failure(let error):
            print("Error reading player document: \(error)")

            if error as? DBError == DBError.notFound{
                throw DBError.notFound
            } else {
                throw error
            }
        }
        
        return player
    }
        
        
    
    
    func getPet(userID: String) async throws -> Pet {
        let collectName = CollectionNames.pets.rawValue
        let petFilter = Filter(from: "user_id", to: userID, op: FilterOperation.EqualTo)
        
        let result: Result<Pet, Error> = await DBService.shared.readNamedDoc(collectName: collectName, docName: userID, filters: [petFilter])
        let pet: Pet
        
        switch result {
        case .success(let petData):
            pet = petData
        case .failure(let error):
            print("Error reading document: \(error)")

            if error as? DBError == DBError.notFound{
                throw DBError.notFound
            } else {
                throw error
            }
        }
        
        return pet
    }
    
    
    func getPetTypes() async throws -> [String:PetType] {
        let collectName = CollectionNames.pet_types.rawValue
        
        let result: Result<[PetType], Error> = await DBService.shared.readCollection(collectName: collectName)
        
        var petTypes: [String:PetType] = [:]
        
        switch result {
        case .success(let petTypeData):
            petTypeData.forEach({ petType in
                petTypes[petType.id] = petType
            })
        case .failure(let error):
            print("Failed to get pet types \(error)")
            throw error
        }
        
        return petTypes
    }
    
    
    func getInventory(userID: String) async throws -> Inventory {
        let collectName = CollectionNames.inventories.rawValue
        
        let result: Result<Inventory, Error> = await DBService.shared.readNamedDoc(collectName: collectName, docName: userID)
        let inventory: Inventory
        
        switch result {
        case .success(let inventoryData):
            inventory = inventoryData
            
            let invItems = try await getInventoryItems(userID: inventory.id)
            
            inventory.items = invItems
        case .failure(let error):
            print("Error reading document: \(error)")

            if error as? DBError == DBError.notFound{
                throw DBError.notFound
            }
            else {
                throw error
            }
        }
        
        return inventory
    }
    
    func getInventoryItems(userID: String) async throws -> [String: InventoryItem] {
        let collectName = CollectionNames.inventory_items.rawValue
        let itemFilter = Filter(from: "user_id", to: userID, op: FilterOperation.EqualTo)
        //let path: String = "\(collectName)/\(userID)"
        
        let result: Result<[InventoryItem], Error> = await DBService.shared.readCollection(collectName: collectName, filters: [itemFilter])
        
        var invItems: [String:InventoryItem] = [:]
        //let baseItems: [String:Item] = try await getItems()
        
        print("getInventory Items User ID:",userID)
        
        switch result {
        case .success(let invItemData):
            print("FIRESTORE INV ITEMS:", invItemData)
            invItemData.forEach({ invItem in
                //let item: Item = baseItems[invItem.id]!
                if invItem.userID == userID{
                    invItems[invItem.id] = invItem
                }
            })
    
        case .failure(let error):
            print("Error reading document: \(error)")
                                    
        }
        
        return invItems
    }
    
    
    func getShop() async throws -> Shop {
        let collectName = CollectionNames.shops.rawValue
        
        let result: Result<Shop, Error> = await DBService.shared.readDoc(collectName: collectName)
        let shop: Shop
        
        switch result {
        case .success(let shopData):
            shop = shopData
            
            let shopItems = try await getShopItems(name: shop.id)
            
            shop.items = shopItems
            
            
        case .failure(let error):
            print("Error reading document: \(error)")
            
            if error as? DBError == DBError.notFound{
                throw DBError.notFound
            } else {
                throw error
            }
        }
        
        return shop
    }
    
    
    func getShopItems(name: String) async throws -> [String: ShopItem] {
        let collectName = CollectionNames.shop_items.rawValue
        let itemFilter = Filter(from: "shop_id", to: name, op: FilterOperation.EqualTo )
        
        let result: Result<[ShopItem], Error> = await DBService.shared.readCollection(collectName: collectName, filters: [itemFilter])
        
        var shopItems: [String:ShopItem] = [:]
        //let baseItems: [String:Item] = try await getItems()
        
        switch result {
        case .success(let shopItemData):
            shopItemData.forEach({ shopItem in
                if shopItem.shopID == name{
                    shopItems[shopItem.id] = shopItem
                }
            })
    
        case .failure(let error):
            print("Error reading document: \(error)")
                                    
        }
        
        return shopItems
    }
    
    
    func showError(error: any Error) -> DBError {
        var dbError: DBError = DBError.unknownError
        
        if let nsError = error as NSError?{
            let fireError = FirestoreErrorCode.Code(rawValue: nsError.code)
            print("Error Domain: \(nsError.domain)")
            
            switch fireError {
            case .notFound:
                dbError = DBError.notFound
            case .cancelled:
                dbError = DBError.cancelled
            default:
                break
            }
        }
        
        print("SHOW ERROR: \(dbError)")
        return dbError
    }
    
    
    func listenToPlayer(userID: String, listened: @escaping (Result <Player, Error>) -> Void) async {
        let collectName = CollectionNames.users.rawValue
        let filters = Filter(from: "user_id", to: userID, op: FilterOperation.EqualTo)
        
        let playerListener = await DBService.shared.addDocumentSnapshotListener(collectName: collectName, filters: [filters]) { (result: Result<Player, Error>) in
            switch result{
            case .success(let playerData):
                //playerData.id = userID
                print("DBUtilitiesIOS: listenToPlayer: SUCCESS \(playerData)")
                listened(.success(playerData))
            case .failure(let error):
                listened(.failure(error))
            }
        }
        
        if playerListener != nil{
            self.listeners.append(playerListener!)
        }
        
        
    }
    
    func listenToPet(userID: String, listened: @escaping (Result <Pet, Error>) -> Void)  async  {
        let collectName = CollectionNames.pets.rawValue
         
        let petListener = DBService.shared.addNamedDocumentSnapshotListener(collectName: collectName, docName: userID) { (result: Result<Pet, Error>) in
            switch result{
            case .success(let petData):
                listened(.success(petData))
                print("DBUtilitiesIOS: listenToPet: SUCCESS \(petData)")
            case .failure(let error):
                listened(.failure(error))
            }
        }
        
            self.listeners.append(petListener)
    }
    
    func listenToInventory(userID: String, listened: @escaping (Result<Inventory, Error>) -> Void) async {
        let collectName = CollectionNames.inventories.rawValue
        let inventoryListener = DBService.shared.addNamedDocumentSnapshotListener(collectName: collectName, docName: userID) { (result: Result<Inventory, Error>) in
            switch result{
            case .success(let inventoryData):
                listened(.success(inventoryData))
                print("DBUtilitiesIOS: listenToInventory: SUCCESS \(inventoryData)")
            case.failure(let error):
                listened(.failure(error))
            }
        }
        
            self.listeners.append(inventoryListener)
    }
    
    func listenToInventoryItems(userID: String, listened: @escaping (Result<InventoryItem, Error>) -> Void)  async {
        let collectName = CollectionNames.inventory_items.rawValue
        let invFilters = Filter(from: "user_id", to: userID, op: FilterOperation.EqualTo)
        let invItemsListener =  DBService.shared.addCollectionSnapshotListener(collectName: collectName, filters: [invFilters]) { (result: Result<InventoryItem, Error>) in
            switch result{
            case .success(let inventoryData):
                listened(.success(inventoryData))
                print("DBUtilitiesIOS: listenToInventory: SUCCESS \(inventoryData)")
            case.failure(let error):
                listened(.failure(error))
            }
        }
        
            self.listeners.append(invItemsListener)
    }
    
    func listenToShop(listened: @escaping (Result<Shop, Error>) -> Void) async {
        let collectName = CollectionNames.shops.rawValue
        let shopListener =  DBService.shared.addCollectionSnapshotListener(collectName: collectName) { (result: Result<Shop, Error>) in
            switch result{
            case .success(let shopData):
                listened(.success(shopData))
                print("DBUtilitiesIOS: listenToShops: SUCCESS \(shopData)")
            case.failure(let error):
                listened(.failure(error))
            }
        }
        
        self.listeners.append(shopListener)
    }
    
    func listenToShopItems(shopID: String, listened: @escaping (Result<ShopItem, Error>) -> Void) async {
        let collectName = CollectionNames.shop_items.rawValue
        let shopFilters = Filter(from: "shop_id", to: shopID, op: FilterOperation.EqualTo)
        let shopItemsListener =  DBService.shared.addCollectionSnapshotListener(collectName: collectName, filters: [shopFilters]) { (result: Result<ShopItem, Error>) in
            switch result{
            case .success(let shopItemData):
                listened(.success(shopItemData))
                print("DBUtilitiesIOS: listenToShops: SUCCESS \(shopItemData)")
            case.failure(let error):
                listened(.failure(error))
            }
        }
        
        self.listeners.append(shopItemsListener)
        
    }
    
    func stopListening(){
        for listener in listeners{
            listener.remove()
        }
        
        listeners.removeAll()
    }
    
    func addPlayer(userID: String, username: String) async {
        
        print("ADD PLAYER IOS")
        let collectName = CollectionNames.users.rawValue
        let data = Player(id: userID, username: username)
        
        await DBService.shared.createNamedDoc(collectName: collectName, docName: userID, data: data)
    }
    
    
    // Currently unused, not sure if useful
    func addInventory(userID: String) async {
        let collectName = CollectionNames.inventories.rawValue
        let inv = Inventory(id: userID)
        
        await DBService.shared.createNamedDoc(collectName: collectName, docName: userID,  data: inv)
    }
    
    func addShop(name: String) async {
        let collectName = CollectionNames.shops.rawValue
        let shop = Shop(name: name)
        
        await DBService.shared.createDoc(collectName: collectName, data: shop)
    }
    
    func addPet(userID: String, name: String, typeID: String) async {
        
        let collectName = CollectionNames.pets.rawValue
        
        let pet = Pet(id: userID, name: name, typeID: typeID)
        
        
        await DBService.shared.createNamedDoc(collectName: collectName, docName: userID, data: pet)
    }
}

