//
//  ContentView.swift
//  petProject Watch App
//
//  Created by Aaron Foster on 2/15/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navCtrl = Navigator()
    @EnvironmentObject var vm : PetViewModel

    
    init(){

    }
    
    var body: some View {
        NavigationStack(path: $navCtrl.navPath){
            LoginView(){ username, password in
                print("LOGIN VIEW LOGIN")
                //if(vm.prevLogin){
                    print("NO PREV LOGIN")
                    Task{ @MainActor in
                        guard username != "" else {return}
                        await vm.login(username: username, password: password)
                    }
                //}
            }
            .navigationDestination(for: Route.self){ dest in
                switch dest{
                case .CreatePetView:
                    CreatePetView(){ name, typeID in
                        
                            Task{ @MainActor in
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
                        navCtrl.navigate(to: .OptionsView)
                    }
                case .InventoryView:
                    InventoryView(){
                        navCtrl.navigate(to: .ShopView)
                    }
                    
                case .OptionsView:
                    OptionsView(){
                        Task{ @MainActor in
                            await vm.logout()
                            navCtrl.navPath.removeAll()
                        }
                    }
                case .ShopView:
                    ShopView()
                }
            }
        }.onChange(of: vm.logged){
            print("logged in on change fired")
            print("got login info")
            
            guard vm.player != nil else {
                print("no player login")
                return
            }
            
            
            
            Task{@MainActor in
                await vm.loggedIn(userID: vm.player!.id, username: "")
            }
        }.onChange(of: vm.ready){
            print("init finished")
            guard vm.player != nil else {
                print("no player login")
                return}
            
            if vm.player?.pet == nil{
                print("navigate to pet creation")
                navCtrl.navigate(to: .CreatePetView)
            }
            else {
                print("navigate to pet view")
                navCtrl.navigate(to: .PetView)
            }
        }
    }
}
