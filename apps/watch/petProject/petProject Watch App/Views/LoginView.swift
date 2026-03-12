//
//  LoginView.swift
//  petProject
//
//  Created by Aaron Foster on 3/5/26.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    private var onLogin: () -> Void
    
    init(onLogin: @escaping () -> Void){
        self.onLogin = onLogin
    }
    
    var body: some View {
        VStack(spacing: 0){
            Text("Username:")
            TextField("", text: $username)
            
            Text("Password:")
            TextField("", text: $password)
            
            Button("Login"){
                self.onLogin()
            }.padding(.top, 8)
        }.padding(.top, 16)
    }
}
