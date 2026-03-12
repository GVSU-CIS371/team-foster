//
//  Pet.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import SwiftUI

struct Pet: View {
    @ObservedObject var vm: PetViewModel
    
    init(vm: PetViewModel) {
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing:30){
                VStack{
                    Text("🙂 Happiness")
                    Text("99")
                }
                
                VStack{
                    Text("🍽️ Hunger")
                    Text("99")
                }
                
                VStack{
                    Text("🫧 Hygiene")
                    Text("99")
                }
            }.frame(maxWidth: .infinity).padding(.vertical, 20).background(Color.blue)

            Spacer()
            
            VStack{
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }.frame(width: 100, height: 100)

            Spacer()
            
            HStack(spacing: 0){
                Button(action:{print("Closet")}){
                    VStack{
                        Text("🎒")
                        Text("Items").foregroundStyle(Color.black).padding(.horizontal, 10).lineLimit(1).fixedSize(horizontal: true, vertical: false)
                    }
                }.background(Color.orange).frame(maxWidth: .infinity)
                Spacer()
                
                Button(action: {print("Pet Played!")}){
                    VStack{
                        Text("🎮")
                        Text("Play").foregroundStyle(Color.black).padding(.horizontal, 10)
                    }
                }.background(Color.green).frame(maxWidth: .infinity)
                
                Spacer()
                
                Button(action: {print("Pet Fed!")}){
                    VStack{
                        Text("🍗")
                        Text("Feed").foregroundStyle(Color.black).padding(.horizontal, 10)
                    }
                }.background(Color.red).frame(maxWidth: .infinity)
                
                Spacer()
                
                Button(action: {print("Pet Washed!")}){
                    VStack{
                        Text("🚿")
                        Text("Wash").foregroundStyle(Color.black).padding(.horizontal, 10)
                    }
                }.background(Color.yellow).frame(maxWidth: .infinity)
                
                Spacer()
                
                Button(action:{print("Options")}){
                    VStack{
                        Text("⚙️")
                        Text("Options").foregroundStyle(Color.black).padding(.horizontal, 10).lineLimit(1).fixedSize(horizontal: true, vertical: false)
                    }
                }.background(Color.purple).frame(maxWidth: .infinity)
                
            }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 10).background(Color.blue).ignoresSafeArea(edges: .all)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
