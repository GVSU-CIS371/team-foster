//
//  Player.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

struct dbPlayer: Codable {
    var id: String
    var username: String
    var currency: Int
    var lastUpdate: Date
}


class Player: Identifiable, Codable{
    var id: String
    var username: String
    var pet: Pet?
    var inventory: Inventory?
    var currency: Int
    var lastUpdate: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case username
        case currency
        case lastUpdate = "last_update"
    }
    
    init(id: String = "test id", username: String = "", pet: Pet? = nil, inventory: Inventory? = nil, currency: Int = 1000, lastUpdate : Date = Date())
    {
        self.id = id
        self.username = username
        self.pet = pet
        self.inventory = inventory
        self.currency = currency
        self.lastUpdate = lastUpdate
    }
}
