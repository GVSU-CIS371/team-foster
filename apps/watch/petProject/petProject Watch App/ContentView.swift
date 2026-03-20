//
//  ContentView.swift
//  petProject Watch App
//
//  Created by Aaron Foster on 2/15/26.
//

import SwiftUI

var testPetType1 = PetType(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, name:"Type 1", image: "", decayRates: PetStats(hunger: 1, happiness: 2, hygiene: 3))

var testPetType2 = PetType(id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, name:"Type 2", image: "", decayRates: PetStats(hunger: 3, happiness: 1, hygiene: 2))

var testPetType3 = PetType(id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, name:"Type 3", image: "", decayRates: PetStats(hunger: 2, happiness: 3, hygiene: 1))

//var testPet = Pet(id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!)

var testPlayer = Player(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!)

var testShop = Shop(id: UUID(uuidString:"33333333-3333-3333-3333-333333333333")!)

var testFood = Item(id: UUID(uuidString:"44444444-4444-4444-4444-444444444444")!)

var testToy = Item(id: UUID(uuidString:"55555555-5555-5555-5555-555555555555")!, type: .Toy)

var testHygiene = Item(id: UUID(uuidString:"66666666-6666-6666-6666-666666666666")!, type: .Hygiene)

var testSFood = ShopItem(id: UUID(uuidString: "77777777-7777-7777-7777-777777777777")!, item: testFood, price: 10)

var testSToy = ShopItem(id: UUID(uuidString: "88888888-8888-8888-8888-888888888888")!, item:testToy, price: 15)

var testSHygiene = ShopItem(id: UUID(uuidString: "99999999-9999-9999-9999-999999999999")!, item: testHygiene, price: 8)


struct ContentView: View {
    @ObservedObject private var navCtrl = Navigator()
    @State var petViewModel = PetViewModel(player: testPlayer, shop: testShop)
    
    init(){
        petViewModel.shop.addShopItem(testSFood)
        petViewModel.shop.addShopItem(testSToy)
        petViewModel.shop.addShopItem(testSHygiene)
        petViewModel.petTypes.append(testPetType1)
        petViewModel.petTypes.append(testPetType2)
        petViewModel.petTypes.append(testPetType3)
    }
    
    var body: some View {
        NavigationStack(path: $navCtrl.navPath){
            LoginView(){
                if petViewModel.player.pet == nil{
                    navCtrl.navigate(to: .CreatePetView)
                }
                else {
                    navCtrl.navigate(to: .PetView)
                }
            }
            .navigationDestination(for: Route.self){ dest in
                switch dest{
                case .CreatePetView:
                    CreatePetView(vm: petViewModel){
                        navCtrl.navigate(to: .PetView)
                    }
                case .PetView:
                    PetView(vm: petViewModel){
                        navCtrl.navigate(to: .InventoryView)
                    } onOptions: {
                        navCtrl.navigate(to: .OptionsView)
                    }
                case .InventoryView:
                    InventoryView(vm: petViewModel){
                        navCtrl.navigate(to: .ShopView)
                    }
                    
                case .OptionsView:
                    OptionsView()
                case .ShopView:
                    ShopView(vm: petViewModel)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
