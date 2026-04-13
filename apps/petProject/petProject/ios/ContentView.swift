//
//  ContentView.swift
//  petProject Watch App
//
//  Created by Aaron Foster on 2/15/26.
//

import SwiftUI

//var testPetType1 = PetType(id: "11111111-1111-1111-1111-111111111111", name:"Type 1", image: "🐦‍⬛", decayRates: PetStats(hunger: 1, happiness: 2, hygiene: 3))

//var testPetType2 = PetType(id:"22222222-2222-2222-2222-222222222222", name:"Type 2", image: "🐼", decayRates: PetStats(hunger: 3, happiness: 1, hygiene: 2))

//var testPetType3 = PetType(id: "33333333-3333-3333-3333-333333333333", name:"Type 3", image: "🐍", decayRates: PetStats(hunger: 2, happiness: 3, hygiene: 1))

//var testPet = Pet(id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!)

//var testPlayer = Player(id: "11111111-1111-1111-1111-111111111111")

//var testShop = Shop(id:"33333333-3333-3333-3333-333333333333")

//var testFood = Item(id:"44444444-4444-4444-4444-444444444444", image: "🍟", type: .Food)

//var testToy = Item(id:"55555555-5555-5555-5555-555555555555", image: "🚂", type: .Toy)

//var testHygiene = Item(id:"66666666-6666-6666-6666-666666666666", image: "🧻", type: .Hygiene)

//var testSFood = ShopItem(itemID: testFood.id, price: 10)

//var testSToy = ShopItem(itemID:testToy.id, price: 15)

//var testSHygiene = ShopItem(itemID: testHygiene.id, price: 8)


struct ContentView: View {

    @EnvironmentObject var vm: PetViewModel

    @ObservedObject var navCtrl = Navigator()
    
    let auth = AuthServiceIOS.shared
    let dbUtil = DBUtilitiesIOS()

    
    var body: some View {
        NavigationStack(path: $navCtrl.navPath){
            LoginView(){ username, password in
                
                Task{ @MainActor in
                    await vm.login(username: username, password: password)
                    await vm.startListeners(userID: vm.player!.id)
                    guard vm.player != nil else { return }
                    
                    if vm.player?.pet == nil{
                        print("BEFORE FIRST NAV")
                        print(ObjectIdentifier(vm.player!))

                        navCtrl.navigate(to: .CreatePetView)
                        print("AFTER FIRST NAV")
                        print(ObjectIdentifier(vm.player!))
                    }
                    else {
                        navCtrl.navigate(to: .PetView)
                    }
                }
                
            }
            .navigationDestination(for: Route.self){ dest in
                switch dest{
                case .CreatePetView:
                    CreatePetView(){ name, typeID in
                        Task{ @MainActor in
                            await vm.newPet(name: name, typeID: typeID)
                            
                            guard vm.player?.pet != nil else {
                                print("NO PET")
                                return }
                            print("BEFORE NAV TO  PET VIEW")
                            print(ObjectIdentifier(vm.player!))
                            navCtrl.navigate(to: .PetView)
                            
                            print("AFTER NAV")
                            print(ObjectIdentifier(vm.player!))
                        }
                    }
                case .PetView:
                    PetView(){
                        navCtrl.navigate(to: .InventoryView)
                    } onOptions: {
                        print("ON OPTIONS")
                        print(ObjectIdentifier(vm.player!))
                        navCtrl.navigate(to: .OptionsView)
                    }
                case .InventoryView:
                    InventoryView(){
                        navCtrl.navigate(to: .ShopView)
                    }
                    
                case .OptionsView:
                    OptionsView()
                case .ShopView:
                    ShopView()
                }
            }
        }.onAppear {
            print("ON APPEAR")
            print(ObjectIdentifier(vm))}
    }
    
}

