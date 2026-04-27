//
//  ContentView.swift
//  petProject Watch App
//
//  Created by Aaron Foster on 2/15/26.
//

import SwiftUI



struct ContentView: View {

    @EnvironmentObject var vm: PetViewModel

    @StateObject var navCtrl = Navigator()
    
    let auth = AuthServiceIOS.shared
    let dbUtil = DBUtilitiesIOS()

    
    var body: some View {
        NavigationStack(path: $navCtrl.navPath){
            LoginView(){ username, password in
                
                Task{ @MainActor in
                    guard username != "" else {return}
                    await vm.login(username: username, password: password)
                    
                    guard vm.player != nil else {
                        print("no player")
                        return }
                    
                    await vm.startListeners(userID: vm.player?.id ?? "")
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
                
            } loggedIn: {
                print("logged in already")
                guard let userID = auth.userID else {return}
                guard let username = auth.username else {return}
                Task{ @MainActor in
                    await vm.loggedIn(userID: userID, username: username)
                    
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
        }.onAppear {
            print("ON APPEAR")
            print(ObjectIdentifier(vm))
            print("Login status", vm.authService.loggedIn)
            print("USERID", vm.authService.userID ?? "no user id")
            if(vm.authService.userID != nil) {
                Task{ @MainActor in
                    print("GETTING USER DATA ON APPEAR")
                    await self.vm.loggedIn(userID: vm.authService.userID!, username: "")
                    
                    print("init finished")


                    guard vm.player != nil else {
                        print("no player login")
                        return}
                    
                    await vm.startListeners(userID: vm.player?.id ?? "")

                    
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
        }.onChange(of: vm.authService.loggedIn) {
            print("login status changed", vm.authService.userID ?? "no user id")
            if(vm.authService.userID != nil){
                Task{ @MainActor in
                    await self.vm.loggedIn(userID: vm.authService.userID!, username: vm.authService.username ?? "")

                    guard vm.player != nil else {
                        print("no player")
                        return }
                    
                    await vm.startListeners(userID: vm.player?.id ?? "")
                    if vm.player?.pet == nil{
                        print("BEFORE FIRST NAV")
                        print(ObjectIdentifier(vm.player!))

                        navCtrl.navigate(to: .CreatePetView)
                        print("AFTER FIRST NAV")
                        print(ObjectIdentifier(vm.player!))
                    }
                    else if vm.player?.pet != nil{
                        print("Navigating to pet view")
                        navCtrl.navigate(to: .PetView)
                    }
                }
            }
            else {
                Task{ @MainActor in
                    navCtrl.navPath.removeAll()
                }
            }
        }
    }
    
}

