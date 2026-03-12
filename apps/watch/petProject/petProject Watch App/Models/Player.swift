//
//  Player.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

@Observable
class Player: Identifiable, ObservableObject{
    let id: UUID
    var username: String = "Default User"
    var pet: Pet? = nil
    var inventory: Inventory
    var currency: Int = 0
    
    init(id: UUID = UUID(), username: String = "Test Player", pet: Pet? = nil, inventory: Inventory = Inventory(), currency: Int = 1000)
    {
        self.id = id
        self.username = username
        self.pet = pet
        self.inventory = inventory
        self.currency = currency
    }
}
