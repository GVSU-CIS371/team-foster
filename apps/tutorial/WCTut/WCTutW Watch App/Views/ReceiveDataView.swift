//
//  ReceiveDataView.swift
//  WCTut
//
//  Created by Aaron Foster on 4/21/26.
//

//
//  ContentView.swift
//  WCTutW Watch App
//
//  Created by Aaron Foster on 4/20/26.
//

import SwiftUI

struct ReceiveDataView: View {
    @ObservedObject var vm: ViewModel
    @State var sent: String = ""
    
    
    init(vm: ViewModel){
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            Text("Sent: \(vm.sentData?.text ?? "none")")
            Text("Received: \(vm.receivedData?.text ?? "none")")
        }
        .padding()
    }
}

