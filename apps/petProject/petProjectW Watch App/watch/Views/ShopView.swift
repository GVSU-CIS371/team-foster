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
    @State private var currentKey: String = ""
    
    private let shop: Shop
    
    init(vm: PetViewModel){
        self._vm = ObservedObject(wrappedValue: vm)
        self.shop = vm.shop!
    }
    
    var body: some View{
        
        VStack{
            Text("$\(String(describing: vm.player?.currency))")
            Spacer()
            ZStack{
                let keys = Array(shop.items.keys)
                TabView(selection: $currentKey){
                    ForEach(keys, id: \.self){ key in
                        if let item = vm.items[key] {
                            VStack{
                                Text(item.name)
                                Text(item.image)
                                Spacer()
                                HStack{
                                    Text(item.type.rawValue)
                                    Spacer()
                                    Text("$\(shop.items[key]!.price)")
                                }.padding(16)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.blue).cornerRadius(10).tag(key)
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
                
                Spacer()
                Button("Buy"){
                    let currentItem = vm.shop?.allShopItems()[currentIndex]
                    vm.buyItem(currentItem!)
                }
                
            }.ignoresSafeArea(edges: .bottom)
        }
    }
}
