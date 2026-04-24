//
//  AuthService.swift
//  petProject
//
//  Created by Aaron Foster on 3/31/26.
//

import SwiftUI
import Combine

enum AuthStatus: Error {
    case IOSOnly
    case failure
}

class AuthServiceWatch: ObservableObject, AuthService{
    static var shared: AuthServiceWatch = AuthServiceWatch()

    var userID: String? = "Default"
    var username: String? = nil
    var loggedIn: Bool

    private let cm: ConnectionManager
    
    required init(cm: ConnectionManager = .shared) {
        self.loggedIn = false
        self.cm = cm
        
        cm.registerData(type: LoginData.self) { data, action, reply in
            print("Login received to watch from phone")
            print(data)
            print(reply)
            
        }
        
    }
    
    func login(email: String, password: String) async -> Result<String, Error>{
        
        return await withCheckedContinuation{ continuation in
 
            print(email)
            let username = String(email.split(separator: "@").first ?? "")
            print(username)
            let loginData = LoginData(id: "testID", email: email, password: password, username: username)
            
            self.cm.sendData(data: loginData, action: ConnectionManager.ActionType.login) { reply in
                guard let response = try? JSONDecoder().decode(ConnectionManager.EncodedMessage.self, from: reply) else {
                    print("reply not received from phone to watch")
                    continuation.resume(returning: .failure(AuthStatus.failure))
                    return
                }
                guard let decoded = try? JSONDecoder().decode(LoginData.self, from: response.payload)
                else {
                    print("reply not decoded from phone to watch")
                    continuation.resume(returning: .failure(AuthStatus.failure))
                    return
                }
                print("decoded: \(decoded.username)")
                
                self.userID = decoded.id
                self.username = decoded.username
                self.loggedIn = true
                print("login authservicewatch", decoded.username)
                print("login authservicewatch", decoded.id)
                
                continuation.resume(returning: .success(self.userID ?? "no user id"))
                }
            }
        
    }
    
    
    func newUser(email: String, password: String) async -> Result<String, any Error> {
        print("new user")
        let response = await login(email: email, password: password)
        
        return response
        
    }
        
    func logout() async {
        print("logout")
        return await withCheckedContinuation{ continuation in
            let loginData = LoginData(id:"", email: "", password: "")
            self.cm.sendData(data: loginData, action: ConnectionManager.ActionType.logout) {reply in
            self.userID = nil
            self.username = nil
            self.loggedIn = false
            print("LOGOUT COMPLETE")
            continuation.resume()
        }
            
        }
    }

    
    func update() {
        print("update")
    }
}
