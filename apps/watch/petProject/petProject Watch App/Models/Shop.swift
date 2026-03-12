//
//  Shop.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

struct ShopItem: Identifiable {
    let id: UUID
    let item: Item
    let price: Int
    var quantity: Int?
    
    init(id: UUID, item: Item, price: Int, quantity: Int? = nil) {
        self.id = id
        self.item = item
        self.price = price
        self.quantity = quantity
    }
}

@Observable
class Shop: Identifiable, ObservableObject {
    let id: UUID
    let name: String
    private(set) var itemsForSale: [ShopItem]
    
    init(id: UUID = UUID(), name: String = "Test Shop", itemsForSale: [ShopItem] = []){
        self.id = id
        self.name = name
        self.itemsForSale = itemsForSale
    }
    
    func addShopItem(_ item: ShopItem){
        self.itemsForSale.append(item)
    }
    
    func allShopItems() -> [ShopItem] {
        return itemsForSale
    }
}
