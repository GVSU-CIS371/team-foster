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
    @State private var checkedLogin: Bool = false
    
    private var onLogin: (String, String) -> Void
    private var loggedIn: () -> Void

    
    init(onLogin: @escaping (String, String) -> Void, loggedIn: @escaping () -> Void){
        /*AuthService.shared.auth.addStateDidChangeListener { (auth, error) in
            
        }*/
        self.onLogin = onLogin
        self.loggedIn = loggedIn
    }
    
    var body: some View {
        VStack(spacing: 0){
            Spacer()
            Text("Pet Project   🐶🐱🐹").font(Font.largeTitle).bold()
            Spacer()
            Text("Username:")
            HStack(spacing: 16){
                Spacer().padding(32)
                TextField("", text: $username).padding(8).border(Color.gray)
                Spacer().padding(32)
            }
            
            Text("Password:")
            HStack(spacing: 16){
                Spacer().padding(32)
                SecureField("", text: $password).padding(8).border(Color.gray)
                Spacer().padding(32)
            }
            Spacer()
            Button("Login"){
                self.onLogin(username, password)
            }.padding(.top, 8).buttonStyle(.bordered)
            Spacer()
        }.padding(.top, 16).onAppear{
            
        }.onDisappear {
            self.username = ""
            self.password = ""
        }
    }
}
