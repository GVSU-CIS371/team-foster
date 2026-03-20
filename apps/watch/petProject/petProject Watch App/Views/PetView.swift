//
//  PetView.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import SwiftUI

struct PetView: View{
    @ObservedObject var vm: PetViewModel
    @State private var missingItem = false
    @State private var alertMessage = ""
    private var onInventory: () -> Void
    private var onOptions: () -> Void
    
    init(vm: PetViewModel, onInventory: @escaping () -> Void, onOptions: @escaping () -> Void) {
        self._vm = ObservedObject(wrappedValue: vm)
        self.onInventory = onInventory
        self.onOptions = onOptions
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing:30){
                VStack{
                    Text("🙂")
                    Text("\(vm.player.pet?.stats.happiness ?? 0)")
                }
                VStack{
                    Text("🍽️")
                    Text("\(vm.player.pet?.stats.hunger ?? 0)")
                }
                VStack{
                    Text("🫧")
                    Text("\(vm.player.pet?.stats.hygiene ?? 0)")
                }
            }.frame(maxWidth: .infinity).background(Color.blue).padding(.top, 32).ignoresSafeArea(edges: .top)

            Spacer()
            
            HStack{
                Button("🎒"){
                    self.onInventory()
                }
                VStack{
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }.frame(width: 100, height: 100)
                Button("⚙️"){
                    self.onOptions()
                }
                
            }.ignoresSafeArea(edges: .all)
            
            Spacer()
            
            HStack(spacing:0){
                Button(action: {
                    if let invItem = vm.player.inventory.allItems.first(where: {$0.item.type == .Toy}){
                        vm.useItem(invItem.item)
                    }
                    else{
                        missingItem = true
                        alertMessage = "You don't have any toys!"
                    }
                    print("Pet Played!")}){
                    VStack{
                        Text("🎮")
                        Text("Play")
                    }
                }
                
                Button(action: {
                    if let invItem = vm.player.inventory.allItems.first(where: {$0.item.type == .Food}){
                        vm.useItem(invItem.item)
                    }
                    else {
                        missingItem = true
                        alertMessage = "You don't have any food!"
                    }
                    print("Pet Fed!")}){
                    VStack{
                        Text("🍗")
                        Text("Feed")
                    }
                }
                
                Button(action: {
                    if let invItem = vm.player.inventory.allItems.first(where: {$0.item.type == .Hygiene}){
                        vm.useItem(invItem.item)
                    }
                    else {
                        missingItem = true
                        alertMessage = "You don't have any hygiene items!"
                    }
                    print("Pet Washed!")}){
                    VStack{
                        Text("🚿")
                        Text("Wash")
                    }
                }
            }.frame(maxWidth: .infinity).background(Color.blue).padding(.bottom, 10).ignoresSafeArea(edges: .bottom)
            
        }.navigationBarBackButtonHidden(true).frame(maxWidth: .infinity, maxHeight: .infinity).alert("Missing Items", isPresented: $missingItem){
            Button("Ok", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
}
