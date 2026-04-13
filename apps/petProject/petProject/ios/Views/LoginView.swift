//
//  LoginView.swift
//  petProject
//
//  Created by Aaron Foster on 3/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    //@State private var loggedIn: Bool = AuthService.shared.auth.currentUser != nil
    @State private var username: String = ""
    @State private var password: String = ""
    
    private var onLogin: (String, String) -> Void
    

    
    init(onLogin: @escaping (String, String) -> Void){
        /*AuthService.shared.auth.addStateDidChangeListener { (auth, error) in
            
        }*/
        self.onLogin = onLogin
    }
    
    var body: some View {
        VStack(spacing: 0){
            Text("Username:")
            TextField("", text: $username)
            
            Text("Password:")
            TextField("", text: $password)
            
            Button("Login"){
                self.onLogin(username + "@test.com", password)
            }.padding(.top, 8)
        }.padding(.top, 16)
    }
}
