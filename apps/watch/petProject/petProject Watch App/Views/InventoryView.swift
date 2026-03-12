//
//  InventoryView.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import SwiftUI

struct InventoryView: View {
    private var onShop: () -> ()
    
    
    init(onShop: @escaping () -> ()){
        self.onShop = onShop
    }
    
    var body: some View{
        Text("Inventory")
        Button("💰"){
            self.onShop()
        }
    }
}
