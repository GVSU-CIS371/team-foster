//
//  ViewModel.swift
//  WCTut
//
//  Created by Aaron Foster on 4/21/26.
//
import Foundation
import SwiftUI
import Combine

struct SomeDataType: Codable { let text: String }

@Observable
class ViewModel: ObservableObject{
    var sentMessage: String? = nil
    var receivedMessage: String? = nil
    var sentData: SomeDataType? = nil
    var receivedData: SomeDataType? = nil
    
    let connectionService: ConnectionService
    
    // to show proof of source
    var platform: String {
        #if os(watchOS)
        return "watchOS"
        #elseif os(iOS)
        return "iOS"
        #endif
    }
    
    
    init(cm: ConnectionService = .shared) {
        self.connectionService = cm
        
        // register message handler
        // (event: "result") is same as ["event":"result"]
        connectionService.register(event: "result"){ [weak self] data, reply in
            DispatchQueue.main.async {
                guard let self else {return}
                self.receivedMessage = (data["result"] as? String ?? "no message") 
                self.sentMessage = (data["result"] as? String ?? "no message") + " " + self.platform
                let outMsg = ["event": "result", "result": self.sentMessage ?? ""]
                reply(outMsg)
            }
        }
        
        
        // register message data handler
        // SomeDataType could be any data type
        connectionService.registerData(type: SomeDataType.self) { [weak self] data, action, reply in
            DispatchQueue.main.async {
                switch action {
                case .success:
                    guard let self else {return}
                    self.receivedData = data
                    self.sentData = SomeDataType(text: data.text + " " + self.platform)
                    reply(self.sentData ?? SomeDataType(text: "no data"))
                default:
                    reply(data)
                }
                
            }
        }
    }
    
    
    func sendMessage(data: [String: Any], replyHandler: (([String: Any]) -> Void)? = nil){
        
        DispatchQueue.main.async {
            self.sentMessage = (data["result"] as? String ?? "no message") + " " + self.platform
            self.connectionService.send(message: data){ reply in
                self.receivedMessage = (reply["result"] as? String ?? "no message")
                replyHandler?(reply)
            }
        }
    }
    
    
    func sendData(data: SomeDataType, replyHandler: ((Data) -> Void)? = nil){
        DispatchQueue.main.async {
            self.sentData = SomeDataType(text: data.text + " " + self.platform)
            self.connectionService.sendData(data: data, action: .success) { reply in
                let envelope = try? JSONDecoder().decode(ConnectionService.MessageDataEnvelope.self, from: reply)
                let decoded = try? JSONDecoder().decode(SomeDataType.self, from: envelope?.payload ?? Data())
                self.receivedData = SomeDataType(text: decoded?.text ?? "no data")
                replyHandler?(reply)
            }
        }
    }
}


