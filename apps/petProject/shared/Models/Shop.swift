//
//  Shop.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

struct ShopItem: Identifiable, Codable{
    var id: String
    var price: Int
    var quantity: Int?
    var shopID: String
    
    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case price
        case quantity
        case shopID = "shop_id"
    }
    
    init(id: String = "", price: Int = -1, quantity: Int? = nil, shopID: String = "") {
        self.id = id
        self.price = price
        self.quantity = quantity
        self.shopID = shopID
    }
}

class Shop: Identifiable, Codable {
    var id: String
    var name: String
    var items: [String: ShopItem] = [:]
    var lastUpdate: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "shop_id"
        case name
        case lastUpdate = "last_update"
    }
    
    init(id: String = "test_id", name: String = "Test Shop", inventory: [String: ShopItem] = [:], lastUpdate: Date = Date()){
        self.id = id
        self.name = name
        self.items = inventory
        self.lastUpdate = lastUpdate
    }
    
    func removeItem(_ item: String) {
        let rmvItem = items[item]
        
        guard rmvItem != nil, rmvItem!.quantity != nil else {return}
        if(rmvItem!.quantity! > 0){
            items[item] = ShopItem(id: item, price: rmvItem!.price, quantity: rmvItem!.quantity! - 1, shopID: rmvItem!.shopID)
        }
    }
    
    func allShopItems() -> [ShopItem] {
        return Array(items.values)
    }
}
