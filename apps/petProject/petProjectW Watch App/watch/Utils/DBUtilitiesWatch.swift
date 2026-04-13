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
    
    func updateInventoryItem(invItem: InventoryItem) async throws {
        print("UPDATE INVENTORY ITEM Watch")
    }
    
    func updateShopItem(shopItem: ShopItem) async throws {
        print("UPDATE SHOP ITEM Watch")
    }
    
    func listenToInventoryItems(userID: String, listened: @escaping (Result<InventoryItem, any Error>) -> Void) async {
        print("Listen to Inventory Items Watch")
    }
    
    
    func listenToShopItems(shopID: String, listened: @escaping (Result<ShopItem, any Error>) -> Void) async {
        print("Listen to Shop Items Watch")
    }
    
    
    func getInventoryItems(userID: String) async throws -> [String : InventoryItem] {
        print("get Inventory Items Watch")
        return [:]
    }
    
    func getShopItems(name: String) async throws -> [String : ShopItem] {
        print("get Shop Items Watch")
        return [:]
    }
    

    
    func getItems() async throws -> [String : Item] {
        print("GET ITEMS WATCH")
        return [:]
    }
    
    func encode<T: Codable>(data: T) throws -> [String : Any]{
        print("ENCODE")
        return [:]
    }
    
    func updatePlayer(userID: String, player: Player) async throws {
        print("UPDATE PLAYER")
    }
    
    func updatePet(userID: String, pet: Pet) async throws {
        print("UPDATE PET")
    }
    
    func updateInventory(userID: String, inventory: Inventory) async throws {
        print("UPDATE INVENTORY")
    }
    
    func updateShop(shopID: String, shop: Shop) async throws {
        print("UPDATE SHOP")
    }
    
    func getPetTypes() async throws -> [String : PetType] {
        print("GET PET TYPES")
        return [:]
    }
    
    func getPlayer(userID: String) async throws -> Player {
        print("WATCH GET PLAYER")
        var wcPlayer: Player = Player()
        
        
        ConnectionManager.shared.send(message: [ConnectionEventType.get.rawValue: "player"], replyHandler: { (playerData) in
            do{
                wcPlayer = try ConnectionManager.shared.decode(data: playerData)
            } catch {
                print("Error getting player")
            }
        })
    
        return wcPlayer
    }
    
    func getPet(userID: String) async throws -> Pet {
        print("WATCH GET PET")
        return Pet()
    }
    
    func getInventory(userID: String) async throws -> Inventory {
        print("WATCH GET INVENTORY")
        return Inventory()
    }
    
    func getShop() async throws -> Shop {
        print("WATCH GET SHOP")
        return Shop()
    }
    
    
    func addPet(userID: String, name: String, typeID: String) async {
        print("WATCH ADD PET")
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
