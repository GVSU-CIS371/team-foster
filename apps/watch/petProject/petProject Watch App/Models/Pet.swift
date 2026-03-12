//
//  Pet.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import Foundation
import Combine

@Observable
class Pet: Identifiable, ObservableObject{
    let id: UUID
    private(set) var name: String = "Default Name"
    private(set) var hunger: Int
    private(set) var happiness: Int
    private(set) var hygiene: Int
    private(set) var equipped: Item?

    private(set) var hungerDecayRate: Int
    private(set) var happinessDecayRate: Int
    private(set) var hygieneDecayRate: Int
    
    init(id: UUID = UUID(), name:String = "Test Pet", hunger: Int = 50, happiness: Int = 50, hygiene: Int = 50, equipped: Item? = nil, hungerDecayRate: Int = 1, happinessDecayRate: Int = 2, hygieneDecayRate: Int = 3){
        self.id = id
        self.name = name
        self.hunger = hunger
        self.happiness = happiness
        self.hygiene = hygiene
        self.equipped = equipped
        self.hungerDecayRate = hungerDecayRate
        self.happinessDecayRate = happinessDecayRate
        self.hygieneDecayRate = hygieneDecayRate
    }
    
    func setName(_ name: String) {
        self.name = name
    }
    
    func updateHunger(_ hunger: Int) {
        self.hunger = min(max(0, hunger), 100)
    }
    
    func updateHappiness(_ happiness: Int) {
        self.happiness = min(max(0, happiness), 100)
    }
    
    func updateHygiene(_ hygiene: Int) {
        self.hygiene = min(max(0, hygiene), 100)
    }
    
    func updateEquipped(_ item: Item?) {
        self.equipped = item
    }
    
    func decayPetStats(){
        let newHunger = self.hunger - self.hungerDecayRate
        let newHappiness = self.happiness - self.happinessDecayRate
        let newHygiene = self.hygiene - self.hygieneDecayRate
        
        self.updateHunger(newHunger)
        self.updateHappiness(newHappiness)
        self.updateHygiene(newHygiene)
    }
}
