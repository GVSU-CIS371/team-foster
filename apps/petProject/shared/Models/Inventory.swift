//
//  Inventory.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

enum ItemType: String, Codable{
    case Food
    case Toy
    case Hygiene
    case Wearable
    case Test
    case none
}

struct Item: Codable, Identifiable, Hashable{
    var id: String
    var name: String
    var description: String?
    var effectValue: Int?
    var image: String
    var type: ItemType
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case effectValue = "effect_value"
        case image
        case type
        
    }
    
    init(id: String = "test id", name: String = "Test Item", description: String = "Test Item Description", effectValue: Int = 5, price: Int = 10, image: String = "❓", type: ItemType = .Food){
        self.id = id
        self.name = name
        self.description = description
        self.effectValue = effectValue
        self.image = image
        self.type = type
    }
}

struct InventoryItem: Identifiable, Codable {
    var id: String
    var quantity: Int
    var userID: String
    
    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case quantity
        case userID = "user_id"
    }
}

class Inventory: Identifiable, Codable{
    var id: String
    var lastUpdate: Date
    var items: [String: InventoryItem] = [:]
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case lastUpdate = "last_update"
    }
    
    var allItems: [InventoryItem] {
        return Array(items.values)
    }
    
    init(id: String = "test ID", items: [String: InventoryItem] = [:], lastUpdate: Date = Date()){
        self.id = id
        self.items = items
        self.lastUpdate = lastUpdate
    }
    
    func update(from other: Inventory) {
        if self.lastUpdate < other.lastUpdate {
            self.items = other.items
        }
    }
    
    func update(from other: [String: InventoryItem]){
        if self.lastUpdate < Date(){
            self.items = other
        }
    }
    
    func update(from other: InventoryItem){
        
        if self.lastUpdate < Date(){
            self.items[other.id] = other
        }
    }
    
    func getItem(_ item: String) -> InventoryItem{
        
        return items[item]!
    }
    
    func addItem(_ item: String, _ userID: String) {
        let newItem = items[item]
        
        if (newItem != nil) {
            items[item] = InventoryItem(id: newItem!.id, quantity: newItem!.quantity + 1, userID: userID)
        }
        else{
            items[item] = InventoryItem(id: item, quantity: 1, userID: userID)
        }
        
    }
    
    func removeItem(_ item: String, userID: String) {
        let rmvItem = items[item]
        
        if(rmvItem != nil){
            items[item] = InventoryItem(id: rmvItem!.id, quantity: rmvItem!.quantity - 1, userID: userID)
            
            if items[item]!.quantity == 0 {
                items[item] = nil
            }
        }
    }
}
