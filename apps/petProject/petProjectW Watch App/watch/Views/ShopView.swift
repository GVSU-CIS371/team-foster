//
//  ShopView.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var vm: PetViewModel
    @State private var currentIndex: Int = 0
    @State private var currentKey: String = ""
    @State private var item: ShopItem? = nil
    var userID: String {
        vm.player?.id ?? ""
    }
    var currency: String {
        String(vm.player?.currency ?? 0)
    }
    
    var keys: [String] {
        Array(vm.shop!.items.keys)
    }
    
    
    init(){

    }
    
    var body: some View{
        
        VStack{
            Text("$\(currency)")
            Spacer()
            ZStack{
                VStack{
                    TabView(selection: $currentKey){
                        ForEach(keys, id: \.self){ key in
                            if let shopItem = vm.shop?.items[key] {
                                if let sItem = vm.items[shopItem.id]{
                                    var quantity: String {
                                        if shopItem.quantity != nil {
                                            String(shopItem.quantity!)
                                        }
                                        else {
                                            "∞"
                                        }
                                    }
                                    
                                    VStack{
                                        Text(sItem.name)
                                        Spacer()
                                        Text(sItem.image).font(.system(size: 30))
                                        Spacer()
                                        HStack{
                                            Text("Price: \(shopItem.price)")
                                            Spacer()
                                            Text("Quantity: \(quantity)")
                                        }
                                            
                                    }.padding(.bottom, 16).padding(.horizontal, 16).frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color.blue).cornerRadius(10).tag(key)
                                }
                            }
                        }
                    }.tabViewStyle(.page)
                }
                
                GeometryReader{geo in
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            print("left")
                            currentIndex = currentIndex > 0 ? currentIndex - 1 : keys.count - 1
                            item = vm.shop!.items[keys[currentIndex]]
                            currentKey = item!.id
                        }.frame(width: geo.size.width/2)
                        Spacer()
                    }
                }
                
                GeometryReader{geo in
                    HStack {
                        Spacer()
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            print("right")
                            currentIndex = currentIndex < keys.count - 1 ? currentIndex + 1 : 0
                            item = vm.shop!.items[keys[currentIndex]]
                            currentKey = item!.id
                        }.frame(width: geo.size.width/2)
                    }
                }
            }
                
                //Spacer()
                Button("Buy"){
                    let currentItem = vm.shop?.allShopItems()[currentIndex]
                    vm.buyItem(currentItem!)
                }
                
            }.ignoresSafeArea(edges: .bottom)
        }
    
}
