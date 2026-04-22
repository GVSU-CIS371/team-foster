//
//  MainMenu.swift
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

struct MainMenu: View {
    private var sendMsg: () -> Void
    private var sendMsgData: () -> Void
    private var waitToReceive: () -> Void
    
    init(sendMsg: @escaping () -> Void, sendMsgData: @escaping () -> Void, waitToReceive: @escaping () -> Void) {
        self.sendMsg = sendMsg
        self.sendMsgData = sendMsgData
        self.waitToReceive = waitToReceive
    }

    var body: some View {
        VStack {
            
            Button("Send Message"){
                self.sendMsg()
            }
            
            Button("Send Message Data"){
                self.sendMsgData()
            }
        
            Button("Wait To Receive"){
                self.waitToReceive()
            }
            
                
        }
        .padding()
    }
}

