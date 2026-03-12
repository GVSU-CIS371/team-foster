//
//  ShopView.swift
//  petProject
//
//  Created by Aaron Foster on 3/10/26.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var vm: PetViewModel
    
    init(vm: PetViewModel){
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    var body: some View{
        Text("$\(vm.player.currency)")
        Spacer()
        ForEach(vm.shop.allShopItems()){ shopItem in
            HStack{
                Text(shopItem.item.name)
                Spacer()
                Text(shopItem.item.type.rawValue)
            }
        }
        Spacer()
        Button("Buy"){}
    }
}
