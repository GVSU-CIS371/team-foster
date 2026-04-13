//
//  Pet.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

struct PetType: Identifiable, Codable{
    let id: String
    let name: String
    let image: String
    let decayRates: PetStats
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case decayRates = "decay_rates"
    }
    
    init(id: String = "testID", name: String = "Test Type", image: String = "❓", decayRates: PetStats = PetStats(hunger: 1, happiness: 2, hygiene: 3)){
        self.id = id
        self.name = name
        self.image = image
        self.decayRates = decayRates
    }
}

struct PetStats: Codable{
    var hunger: Int = 50
    var happiness: Int = 50
    var hygiene: Int = 50
    
    init(hunger: Int = 50, happiness: Int = 50, hygiene: Int = 50) {
        self.hunger = hunger
        self.happiness = happiness
        self.hygiene = hygiene
    }
}

class Pet: Identifiable, Codable{
    var id: String?
    private(set) var name: String
    private(set) var typeID: String
    var stats: PetStats
    private(set) var equipped: String?
    var lastUpdate: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case typeID
        case stats
        case equipped
        case lastUpdate = "last_update"
    }

    
    init(id: String = "test ID", name:String = "Test Pet", typeID: String = "Test Type", stats: PetStats = PetStats(), equipped: String? = nil, lastUpdate: Date = Date()){
        self.id = id
        self.name = name
        self.typeID = typeID
        self.stats = stats
        self.equipped = equipped
        self.lastUpdate = lastUpdate
    }
    
    
    func setName(_ name: String) {
        self.name = name
    }
    
    func updateHunger(_ hunger: Int) {
        self.stats.hunger = min(max(0, self.stats.hunger + hunger), 100)
    }
    
    func updateHappiness(_ happiness: Int) {
        self.stats.happiness = min(max(0, self.stats.happiness + happiness), 100)
    }
    
    func updateHygiene(_ hygiene: Int) {
        self.stats.hygiene = min(max(0, self.stats.hygiene + hygiene), 100)
    }
    
    func updateEquipped(_ item: String?) {
        self.equipped = item
    }
    
    func decayPetStats(type: PetType, intervals: Int = 1){
        let newHunger = -type.decayRates.hunger * intervals
        let newHappiness = -type.decayRates.happiness * intervals
        let newHygiene = -type.decayRates.hygiene * intervals
        
        self.updateHunger(newHunger)
        self.updateHappiness(newHappiness)
        self.updateHygiene(newHygiene)
    }
    
    func update(from other: Pet){
        if other.id != self.id {
            self.id = other.id
        }
        
        if self.name != other.name {
            self.name = other.name
        }

        if other.typeID != self.typeID{
            self.typeID = other.typeID
        }
        
        if self.stats.hunger > other.stats.hunger {
            self.stats.hunger = other.stats.hunger
        }
        
        if self.stats.happiness > other.stats.happiness {
            self.stats.happiness = other.stats.happiness
        }
        
        if self.stats.hygiene > other.stats.hygiene {
            self.stats.hygiene = other.stats.hygiene
        }
        
        if other.equipped != nil {
            self.equipped = other.equipped
        }
        
        if other.lastUpdate > self.lastUpdate {
            self.lastUpdate = other.lastUpdate
        }
    }
}
