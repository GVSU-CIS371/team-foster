//
//  InventoryView.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import SwiftUI

struct InventoryView: View {
    @EnvironmentObject private var vm: PetViewModel
    private var onShop: () -> ()
    @State private var currentIndex: Int = 0
    @State private var currentKey: String = ""
    @State private var item: InventoryItem? = nil
    
    var userID: String {
        vm.player?.id ?? ""
    }
    
    var keys: [String] {
        Array(vm.player!.inventory!.items.keys)
    }
    
    init(onShop: @escaping () -> ()){
        self.onShop = onShop
    }

    
    var body: some View{
        VStack{
            Text("Inventory")
            Spacer()
            VStack{
            ZStack{
                VStack{
                    TabView(selection: $currentKey){
                        ForEach(keys, id: \.self){ key in
                            if let invItem = vm.player?.inventory?.items[key] {
                                if let iItem = vm.items[invItem.id] {
                                    VStack{
                                        Text(iItem.name)
                                        Spacer()
                                        Text(iItem.image).font(.system(size: 200))
                                        Spacer()
                                        HStack{
                                            Text(iItem.type.rawValue)
                                            Spacer()
                                            VStack{
                                                Text("Effect Value: \(String(iItem.effectValue ?? -1))")
                                                Text("Quantity: \(String(invItem.quantity))")
                                            }
                                        }.padding(16)
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color.blue).cornerRadius(10).tag(key)
                                }
                            }
                        }
                    }.tabViewStyle(.page)
                }
                
                GeometryReader{geo in
                    HStack {
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            currentIndex = currentIndex > 0 ? currentIndex - 1 : keys.count - 1
                            item = vm.player!.inventory!.items[keys[currentIndex]]
                            currentKey = item!.id
                        }.frame(width: geo.size.width/2)
                        Spacer()
                    }
                }
                
                GeometryReader{geo in
                    HStack {
                        Spacer()
                        Color.clear.contentShape(Rectangle()).onTapGesture {
                            currentIndex = currentIndex < keys.count - 1 ? currentIndex + 1 : 0
                            item = vm.player!.inventory!.items[keys[currentIndex]]
                            currentKey = item!.id
                        }.frame(width: geo.size.width/2)
                    }
                }
                
            }.frame(maxHeight: .infinity)
            
 
                //Spacer()
                Button("Shop 💰"){
                    self.onShop()
                }.padding(32).font(.system(size: 16)).buttonStyle(.bordered).padding(.bottom, 48)
            }
        }.onAppear{

        }
    }
    
}
