//
//  ReceiveMessageView.swift
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

struct ReceiveMessageView: View {
    @ObservedObject var vm: ViewModel
    
    
    init(vm: ViewModel){
        self._vm = ObservedObject(wrappedValue: vm)

    }
    
    var body: some View {
        VStack {
            Text("Sent: \(vm.sentMessage ?? "None")")
            Text("Received: \(vm.receivedMessage ?? "None")")
        }
        .padding()
    }
}
