//
//  ShopView.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var vm: PetViewModel
    @State private var currentIndex: Int = 0
    
    init(vm: PetViewModel){
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    var body: some View{
    
        VStack{
            Text("$\(vm.player.currency)")
            Spacer()
            ZStack{
                TabView(selection: $currentIndex){
                    ForEach(Array(vm.shop.allShopItems().enumerated()), id: \.element.id){ index, shopItem in
                        VStack{
                            Text(shopItem.item.name)
                            Spacer()
                            HStack{
                                Text(shopItem.item.type.rawValue)
                                Spacer()
                                Text("$\(shopItem.price)")
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
                            currentIndex = vm.shop.allShopItems().count - 1
                        }
                    }
                }
                
                HStack {
                    Color.clear.contentShape(Rectangle()).onTapGesture {
                        if currentIndex < vm.shop.allShopItems().count - 1 {
                            currentIndex += 1
                        }
                        else if currentIndex >= vm.shop.allShopItems().count - 1 {
                            currentIndex = 0
                        }
                    }
                }
            }
            
            Spacer()
            Button("Buy"){
                let currentItem = vm.shop.allShopItems()[currentIndex]
                vm.buyItem(currentItem)
            }
            
        }.ignoresSafeArea(edges: .bottom)
    }
}
