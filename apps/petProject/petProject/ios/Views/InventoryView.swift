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
                                        HStack{
                                            Text(iItem.type.rawValue)
                                            Spacer()
                                            Text(String(invItem.quantity))
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
                            print("left")
                            currentIndex = currentIndex > 0 ? currentIndex - 1 : keys.count - 1
                            item = vm.player!.inventory!.items[keys[currentIndex]]
                            currentKey = item!.id
                            print("\(currentIndex) \(currentKey) \(String(describing: item))")
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
                            item = vm.player!.inventory!.items[keys[currentIndex]]
                            currentKey = item!.id
                            print("\(currentIndex) \(currentKey) \(String(describing: item))")
                        }.frame(width: geo.size.width/2)
                    }
                }
                
            }
            
 
                //Spacer()
                Button("💰"){
                    self.onShop()
                }
                Spacer()
            }
        }.onAppear{

        }
    }
    
}
