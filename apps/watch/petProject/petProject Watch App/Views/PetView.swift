//
//  Pet.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import SwiftUI

struct Pet: View{
    @ObservedObject var vm: PetViewModel
    
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
                    Text("99")
                }
                VStack{
                    Text("🍽️")
                    Text("99")
                }
                VStack{
                    Text("🫧")
                    Text("99")
                }
            }.navigationBarBackButtonHidden(true).frame(maxWidth: .infinity).background(Color.blue).padding(.top, 32).ignoresSafeArea(edges: .top)

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
                Button(action: {print("Pet Played!")}){
                    VStack{
                        Text("🎮")
                        Text("Play")
                    }
                }
                
                Button(action: {print("Pet Fed!")}){
                    VStack{
                        Text("🍗")
                        Text("Feed")
                    }
                }
                
                Button(action: {print("Pet Washed!")}){
                    VStack{
                        Text("🚿")
                        Text("Wash")
                    }
                }
            }.frame(maxWidth: .infinity).background(Color.blue).padding(.bottom, 10).ignoresSafeArea(edges: .bottom)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
