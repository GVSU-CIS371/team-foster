//
//  SendDataView.swift
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

struct SendDataView: View {
    @State private var message: String = ""
    private var sendData: (SomeDataType) -> Void

    
    init(sendData: @escaping (SomeDataType) -> Void){
        self.sendData = sendData
    }
    
    var body: some View {
        VStack {
            Text("Enter Object Message...")
            TextField("", text: $message)
            Button("Send"){
                let data = SomeDataType(text: self.message)
                self.sendData(data)
            }
                
        }
        .padding()
    }
}

