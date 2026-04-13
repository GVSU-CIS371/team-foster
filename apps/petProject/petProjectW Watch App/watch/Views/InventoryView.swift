//
//  InventoryView.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import SwiftUI

struct InventoryView: View {
    @ObservedObject var vm: PetViewModel
    private var onShop: () -> ()
    @State private var currentIndex: Int = 0
    @State private var currentKey: String = ""
    
    @State private var inventory: Inventory = Inventory()
    
    init(vm: PetViewModel, onShop: @escaping () -> ()){
        self._vm = ObservedObject(wrappedValue: vm)
        self.onShop = onShop
    }
    
    var body: some View{
        VStack{
            Text("Inventory")
            Spacer()
            ZStack{
                let keys = Array(inventory.items.keys)

                if inventory.allItems.isEmpty{
                    Text("No Items").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
                }
                else {
                    TabView(selection: $currentIndex){
                        ForEach(keys, id: \.self){ key in
                            if let item = vm.items[key] {
                                VStack{
                                    Text(item.name)
                                    Spacer()
                                    HStack{
                                        Text(item.type.rawValue)
                                        Spacer()
                                        Text(String(inventory.items[key]!.quantity))
                                    }.padding(16)
                                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.blue).cornerRadius(10).tag(key)
                            }
                        }
                    }.tabViewStyle(.page)
                    
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            guard let currentIndex = keys.firstIndex(of: currentKey) else {return}
                            let prevIndex = currentIndex > 0 ? currentIndex - 1 : keys.count - 1
                            currentKey = keys[prevIndex]
                        }
                    }
                    
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            guard let currentIndex = keys.firstIndex(of: currentKey) else {return}
                            let prevIndex = currentIndex < keys.count - 1 ? currentIndex + 1 : 0
                            currentKey = keys[prevIndex]
                        }
                    }
                }
            }
            Spacer()
            Button("💰"){
                self.onShop()
            }
        }.ignoresSafeArea(edges: .bottom)
            .onAppear {
                if vm.player!.inventory == nil {
                    Task{@MainActor in
                        inventory = Inventory(id: vm.player!.id)
                        vm.player!.inventory = inventory
                    }
                }
            }
    }
}
