//
//  SendMessageView.swift
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

struct SendMessageView: View {
    @State private var message: String = ""
    private var sendMsg: ([String: Any]) -> Void
    
    init(sendMsg: @escaping ([String: Any]) -> Void){
        self.sendMsg = sendMsg
    }
    
    var body: some View {
        VStack {
            Text("Enter Message...")
            TextField("", text: $message)
            Button("Send"){
                let msg = ["event":"result", "result": self.message] as [String : Any]
                self.sendMsg(msg)
            }
        }
        .padding()
    }
}
