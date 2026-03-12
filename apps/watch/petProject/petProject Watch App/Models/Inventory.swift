//
//  Inventory.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

enum ItemType: String{
    case Food
    case Toy
    case Hygiene
    case Wearable
}

struct Item: Identifiable, Hashable{
    let id: UUID
    let name: String
    let description: String
    let effectValue: Int
    let price: Int
    let image: String
    let type: ItemType
    
    init(id: UUID = UUID(), name: String = "Test Item", description: String = "Test Item Description", effectValue: Int = 5, price: Int = 10, image: String = "testItem", type: ItemType = .Food){
        self.id = id
        self.name = name
        self.description = description
        self.effectValue = effectValue
        self.price = price
        self.image = image
        self.type = type
    }
}

struct InventoryItem {
    var item: Item
    var quantity: Int
}

@Observable
class Inventory: ObservableObject {
    private(set) var items: [UUID: InventoryItem] = [:]
    
    var allItems: [InventoryItem] {
        return Array(items.values)
    }
    
    init(items: [UUID: InventoryItem] = [:]){
        self.items = items
    }
    
    func addItem(_ item: Item) {
        let newItem = items[item.id]
        
        if (newItem != nil) {
            items[item.id] = InventoryItem(item: newItem!.item, quantity: newItem!.quantity + 1)
        }
        else{
            items[item.id] = InventoryItem(item: item, quantity: 1)
        }
        
    }
    
    func removeItem(_ item: Item) {
        let rmvItem = items[item.id]
        
        if(rmvItem != nil){
            if (rmvItem!.quantity > 1){
                items[item.id] = InventoryItem(item: rmvItem!.item, quantity: rmvItem!.quantity - 1)
            }
            else {
                items.removeValue(forKey: item.id)
            }
        }
    }
}
