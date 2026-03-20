//
//  PetViewModel.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import Foundation
import SwiftUI
import Combine

@Observable
class PetViewModel: ObservableObject {
    var player: Player
    var shop: Shop
    var petTypes: [PetType] = []
    private var timer:Timer = Timer()
    
    init(player: Player, shop: Shop){
        self.player = player
        self.shop = shop
        petTimer()
    }
    
    func petTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true){ _ in
            self.player.pet?.decayPetStats()
        }
    }
    
    func newPet(name: String, type: PetType){
        self.player.pet = Pet(name: name, type: type, stats: PetStats(hunger: 100, happiness: 100, hygiene: 100))
    }
    
    func buyItem(_ shopItem: ShopItem){
        if player.currency >= shopItem.price{
            player.currency -= shopItem.price
            player.inventory.addItem(shopItem.item)
        }
    }
    
    func useItem(_ item: Item){
        switch item.type{
        case .Food:
            player.pet?.updateHunger(item.effectValue)
        case .Toy:
            player.pet?.updateHappiness(item.effectValue)
        case .Hygiene:
            player.pet?.updateHygiene(item.effectValue)
        case .Wearable:
            player.pet?.updateEquipped(item)
        }
        
        if item.type != .Wearable{
            player.inventory.removeItem(item)
        }
    }
}
