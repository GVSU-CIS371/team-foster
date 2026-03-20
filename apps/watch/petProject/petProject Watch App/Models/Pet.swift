//
//  Pet.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

struct PetType {
    let id: UUID
    let name: String
    let image: String
    let decayRates: PetStats
    
    init(id: UUID = UUID(), name: String = "Test Type", image: String = "testImage", decayRates: PetStats = PetStats(hunger: 1, happiness: 2, hygiene: 3)){
        self.id = id
        self.name = name
        self.image = image
        self.decayRates = decayRates
    }
}

struct PetStats{
    var hunger: Int = 50
    var happiness: Int = 50
    var hygiene: Int = 50
    
    init(hunger: Int = 50, happiness: Int = 50, hygiene: Int = 50) {
        self.hunger = hunger
        self.happiness = happiness
        self.hygiene = hygiene
    }
}

@Observable
class Pet: Identifiable, ObservableObject{
    let id: UUID
    private(set) var name: String = "Default Name"
    private(set) var type: PetType
    private(set) var stats: PetStats
    private(set) var equipped: Item?

    
    init(id: UUID = UUID(), name:String = "Test Pet", type: PetType = PetType(), stats: PetStats = PetStats(), equipped: Item? = nil){
        self.id = id
        self.name = name
        self.type = type
        self.stats = stats
        self.equipped = equipped
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
    
    func updateEquipped(_ item: Item?) {
        self.equipped = item
    }
    
    func decayPetStats(){
        let newHunger = -self.type.decayRates.hunger
        let newHappiness = -self.type.decayRates.happiness
        let newHygiene = -self.type.decayRates.hygiene
        
        self.updateHunger(newHunger)
        self.updateHappiness(newHappiness)
        self.updateHygiene(newHygiene)
    }
}
