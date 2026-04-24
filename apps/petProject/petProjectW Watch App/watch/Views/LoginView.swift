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
    
    private var onLogin: (String, String) -> Void
    
    init(onLogin: @escaping (String, String) -> Void){
        self.onLogin = onLogin
    }
    
    var body: some View {
        VStack(spacing: 0){
            Text("Username:")
            TextField("", text: $username)
            
            Text("Password:")
            SecureField("", text: $password)
            
            Button("Login"){
                self.onLogin(username, password)
            }.padding(.top, 8)
        }.padding(.top, 16).onAppear{
            print("ON APPEAR LOGIN")
            username = ""
            password = ""
            self.onLogin("a", "1")
        }
    }
}
