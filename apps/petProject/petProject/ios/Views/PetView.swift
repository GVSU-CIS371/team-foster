//
//  PetView.swift
//  petProject
//  iOS
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
                    Text("🙂").font(Font.system(size: buttonSize))
                    Text(happiness)
                }
                VStack{
                    Text("🍽️").font(Font.system(size: buttonSize))
                    Text(hunger)
                }
                VStack{
                    Text("🫧").font(Font.system(size: buttonSize))
                    Text(hygiene)
                }
            }.frame(maxWidth: .infinity).background(Color.blue).padding(.top, 32)

            Spacer()
            
            HStack{
 
                VStack{
                    Text(petImage).font(.system(size: 330))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)

                
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    self.onInventory()
                }){
                    VStack{
                        Text("🎒").font(.system(size: buttonSize))
                        Text("Items").foregroundStyle(fontColor)
                    }
                    
                }.frame(maxWidth: .infinity).border(Color.black, width: 2)
                
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
                        Text("🎮").font(.system(size: buttonSize * 2))
                        Text("Play").foregroundStyle(fontColor)
                    }
                }.frame(maxWidth: .infinity).border(Color.black, width: 2)
                
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
                        Text("🍗").font(.system(size: buttonSize * 2))
                        Text("Feed").foregroundStyle(fontColor)
                    }
                }.frame(maxWidth: .infinity).border(Color.black, width: 2)
                
                Button(action: {
                    Task {@MainActor in
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
                        Text("🚿").font(.system(size: buttonSize * 2))
                        Text("Wash").foregroundStyle(fontColor)
                    }
                }.frame(maxWidth: .infinity).border(Color.black, width: 2)
                
                Button(action: {
                    self.onOptions()}){
                        VStack{
                            Text("⚙️").font(.system(size: buttonSize))
                            Text("Menu").foregroundStyle(fontColor)
                        }
                }.frame(maxWidth: .infinity).border(Color.black, width: 2)
            }.frame(maxWidth: .infinity).padding(.horizontal, 16).background(Color.blue).padding(.bottom, 10)
            
        }.navigationBarBackButtonHidden(true).frame(maxWidth: .infinity, maxHeight: .infinity).alert("Missing Items", isPresented: $missingItem){
            Button("Ok", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }.onAppear {
            print("PET VIEW")
            print(ObjectIdentifier(vm.player!))

        }
    }
}
