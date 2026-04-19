//
//  PetView.swift
//  petProject
//  Watch
//  Created by Aaron Foster on 3/1/26.
//

import SwiftUI

struct PetView: View{
    @EnvironmentObject var vm: PetViewModel
    @State private var missingItem = false
    @State private var alertMessage = ""
    var userID: String {
        vm.player?.id ?? ""
    }
    var happiness: String {
        String(vm.player?.pet?.stats.happiness ?? -1)
    }
    
    var hunger: String {
        String(vm.player?.pet?.stats.hunger ?? -1)
    }
    
    var hygiene: String {
        String(vm.player?.pet?.stats.hygiene ?? -1)
    }
    
    var typeID: String {
        vm.player?.pet?.typeID ?? ""
    }
    
    var petImage: String {
        vm.petTypes[typeID]?.image ?? "⁉️"
    }
    
    private var onInventory: () -> Void
    private var onOptions: () -> Void
    private let buttonSize: CGFloat = 32
    private let fontColor: Color = .red

    
    init(onInventory: @escaping () -> Void, onOptions: @escaping () -> Void) {
        self.onInventory = onInventory
        self.onOptions = onOptions
    
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing:30){
                VStack{
                    Text("🙂")
                    Text("\(happiness)")
                }
                VStack{
                    Text("🍽️")
                    Text("\(hunger)")
                }
                VStack{
                    Text("🫧")
                    Text("\(hygiene)")
                }
            }.frame(maxWidth: .infinity).background(Color.blue).padding(.top, 32).ignoresSafeArea(edges: .top)

            Spacer()
            
            HStack{
                Button("🎒"){
                    self.onInventory()
                }
                VStack{
                    Text(petImage).font(Font.largeTitle.bold())
                }.frame(width: 100, height: 100)
                Button("⚙️"){
                    self.onOptions()
                }
                
            }.ignoresSafeArea(edges: .all)
            
            Spacer()
            
            HStack(spacing:0){
                Button(action: {
                    Task{@MainActor in
                        if vm.hasItem("Toy"){
                            await vm.useFirstItemOfType(typeID: "Toy")
                        } else                        {
                            missingItem = true
                            alertMessage = "You don't have any toys!"
                        }
                    }
                    print("Pet Played!")}){
                    VStack{
                        Text("🎮")
                        Text("Play")
                    }
                }
                
                Button(action: {
                    Task {@MainActor in
                        if vm.hasItem("Food"){
                            await vm.useFirstItemOfType(typeID: "Food")
                        } else                        {
                            missingItem = true
                            alertMessage = "You don't have any food!"
                        }
                    }
                    print("Pet Fed!")}){
                    VStack{
                        Text("🍗")
                        Text("Feed")
                    }
                }
                
                Button(action: {
                    Task{@MainActor in
                        if vm.hasItem("Hygiene"){
                            await vm.useFirstItemOfType(typeID: "Hygiene")
                        } else
                        {
                            missingItem = true
                            alertMessage = "You don't have any hygiene items!"
                        }
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
