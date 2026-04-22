//
//  ContentView.swift
//  WCTut
//
//  Created by Aaron Foster on 4/20/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var vm: ViewModel
    @State var payload: String = ""
    
    var msgReceived: String {
        vm.receivedMessage ?? "No message received"
    }
    
    var msgSent: String {
        vm.sentMessage ?? "No message sent"
    }
    
    var dataReceived: SomeDataType {
        vm.receivedData ?? SomeDataType(text: "no data received")
    }
    
    var dataSent: SomeDataType {
        vm.sentData ?? SomeDataType(text: "no data sent")
    }
    
    
    init(){
        self._vm = ObservedObject(wrappedValue: ViewModel())
    }

    var body: some View {
        
        VStack{
            HStack{
                VStack{
                    Text("Sent Message")
                    Text(msgSent)
                }
                
                VStack{
                    Text("Received Message")
                    Text(msgReceived)
                }
            }
            
            HStack{
                
                VStack{
                    Text("Sent Data")
                    Text(dataSent.text)
                }
                
                VStack{
                    Text("Received Data")
                    Text(dataReceived.text)
                }
            }
        
        
            Text("Enter payload")
            TextField("", text: $payload)
            
            HStack{
                Button("Send as Message"){
                    let message = ["event": "result", "result": self.payload]
                    DispatchQueue.main.async {
                        self.vm.sentMessage = message["result"] ?? "no result"
                    }
                    
                    vm.sendMessage(data: message){ reply in
                        
                        DispatchQueue.main.async{
                            self.vm.receivedMessage = (reply["result"] as? String ?? "no result ")
                        }
                    }
                    
                }
                Button("Send as Data"){
                    let data = SomeDataType(text: self.payload)
                    DispatchQueue.main.async {
                        self.vm.sentData = data
                    }
                    vm.sendData(data: data){ reply in
                        print("REPLY RECEIVED")
                        guard let decoded = try? JSONDecoder().decode(ConnectionService.MessageDataEnvelope.self, from: reply) else { return }
                        guard let result = try? JSONDecoder().decode(SomeDataType.self, from: decoded.payload) else { return }
                        let received = SomeDataType(text: result.text)
                        
                        DispatchQueue.main.async{
                            self.vm.receivedData = received
                        }
                        
                    }
                }
                
                
            }
        }
    }

   
}
