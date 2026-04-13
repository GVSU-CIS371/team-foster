//
//  DBUtilities.swift
//  petProject
//
//  Created by Aaron Foster on 4/2/26.
//

import SwiftUI

enum DBError: Error {
    case notFound
    case unknownError
    case cancelled
}


enum CollectionNames: String {
    case items
    case pet_types
    case shops
    case shop_items
    case users
    case pets
    case inventories
    case inventory_items
}

enum FilterOperation {
    case EqualTo
    case LessThan
    case LessThanOrEqualTo
    case GreaterThan
    case GreaterThanOrEqualTo
    case In
    case NotIn
    case Contains
    case ContainsAny
}

struct Filter {
    var from: String
    var to: Any
    var op: FilterOperation
    
    init(from: String, to: Any, op: FilterOperation) {
        self.from = from
        self.to = to
        self.op = op
    }
}



protocol DBUtilities {
    func encode<T: Codable>( data: T) throws -> [String: Any]
    func listenToPlayer(userID: String, listened: @escaping (Result<Player, Error>) -> Void) async
    func listenToPet(userID: String, listened: @escaping (Result<Pet,Error>) -> Void) async
    func listenToInventory(userID: String, listened: @escaping (Result<Inventory, Error>) -> Void) async
    func listenToInventoryItems(userID: String, listened: @escaping (Result<InventoryItem, Error>) -> Void) async
    func listenToShop(listened: @escaping (Result<Shop, Error>) -> Void) async
    func listenToShopItems(shopID: String, listened: @escaping (Result<ShopItem, Error>) -> Void) async

    func addPlayer(userID: String, username: String) async
    func addPet(userID: String, name: String, typeID: String) async
    func addInventory(userID: String) async
    func addShop(name: String) async

    func getPlayer(userID: String) async throws -> Player
    func getPet(userID: String) async throws -> Pet
    func getPetTypes() async throws -> [String:PetType]
    func getInventory(userID: String) async throws -> Inventory
    func getInventoryItems(userID: String) async throws -> [String: InventoryItem]
    func getShop() async throws -> Shop
    func getShopItems(name: String) async throws -> [String: ShopItem]
    func getItems() async throws -> [String:Item]
    
    func updatePlayer(userID:String, player: Player) async throws-> Void
    func updatePet(userID:String, pet: Pet) async throws -> Void
    func updateInventory(userID:String, inventory: Inventory) async throws -> Void
    func updateInventoryItem(invItem: InventoryItem) async throws -> Void
    func updateShop(shopID: String, shop: Shop) async throws -> Void
    func updateShopItem(shopItem: ShopItem) async throws -> Void
    
    func showError(error: Error) -> DBError
}
