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
    
    
    
    init(vm: PetViewModel, onShop: @escaping () -> ()){
        self._vm = ObservedObject(wrappedValue: vm)
        self.onShop = onShop
    }
    
    var body: some View{
        VStack{
            Text("Inventory")
            Spacer()
            ZStack{
                if vm.player.inventory.allItems.isEmpty{
                    Text("No Items").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
                }
                else {
                    TabView(selection: $currentIndex){
                        ForEach(vm.player.inventory.allItems.enumerated(), id: \.element.item.id){ index, invItem in
                            VStack{
                                Text(invItem.item.name)
                                Spacer()
                                HStack{
                                    Text(invItem.item.type.rawValue)
                                    Spacer()
                                    Text(String(invItem.quantity))
                                }.padding(16)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.blue).cornerRadius(10).tag(index)
                        }
                    }.tabViewStyle(.page)
                    
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                            else if currentIndex < 0 {
                                currentIndex = vm.player.inventory.allItems.count - 1
                            }
                        }
                    }
                    
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            if currentIndex < vm.player.inventory.allItems.count - 1 {
                                currentIndex += 1
                            }
                            else if currentIndex >= vm.player.inventory.allItems.count - 1 {
                                currentIndex = 0
                            }
                        }
                    }
                }
            }
            Spacer()
            Button("💰"){
                self.onShop()
            }
        }.ignoresSafeArea(edges: .bottom)
    }
}
