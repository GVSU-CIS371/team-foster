//
//  WaitView.swift
//  WCTut
//
//  Created by Aaron Foster on 4/21/26.
//

import SwiftUI

struct WaitView: View {
    @ObservedObject var vm: ViewModel
    @State var received: String = ""
    @State var sent: String = ""
        
    init(vm: ViewModel){
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            Text("Received")
            Text(received)
            Text("Sent")
            Text(sent)
        }.onChange(of: self.vm.sentMessage){
            self.sent = self.vm.sentMessage ?? "no message"
        }.onChange(of: self.vm.sentData?.text){
            self.sent = self.vm.sentData?.text ?? "no data"
        }.onChange(of: self.vm.receivedMessage){
            self.received = self.vm.receivedMessage ?? "no message"
        }.onChange(of: self.vm.receivedData?.text){
            self.received = self.vm.receivedData?.text ?? "no data"
        }
        
        .padding()
        
    }
}
