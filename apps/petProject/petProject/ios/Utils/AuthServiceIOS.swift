//
//  AuthService.swift
//  petProject
//
//  Created by Aaron Foster on 3/31/26.
//

import SwiftUI
import Combine
import FirebaseAuth
import Security

@Observable
class AuthServiceIOS: ObservableObject, AuthService{
    
    var userID: String? = nil
    var username: String? = nil
    var loggedIn: Bool
    
    static let shared = AuthServiceIOS()
    
    let auth = Auth.auth()
    private let cm: ConnectionManager
    private let cu = ConnectionUtilsIOS()

    
    required internal init(cm: ConnectionManager = .shared) {
        self.userID = auth.currentUser?.uid
        self.username = auth.currentUser?.displayName ?? "no name"
        self.loggedIn = auth.currentUser != nil
        self.cm = cm

        
        cm.registerData(type: LoginData.self) { data, action, reply in
            print("Login received to phone from watch")
            print(data)
            
            print(self.userID ?? "no user")

            switch action{
                
            case .login:
                print("login received")
                if(data.password.count > 5){
                    Task{ @MainActor in
                        print("registerData login task")
                        if(!self.loggedIn){
                            let result = await self.newUser(email: data.email, password: data.password)
                            
                            switch result {
                            case .success:
                                print("login success")
                                self.userID = self.auth.currentUser?.uid
                                self.username = data.username
                                self.loggedIn = true
                                reply(LoginData(id: self.userID ?? "", email: self.username! + "@test.com",password: "", username: self.username!, success: true))
                                
                            case .failure:
                                print("login failure")
                                reply(LoginData(email: "", username: ""))
                            }
                        } else {
                            print("login other")
                            let email = self.auth.currentUser?.email ?? "no email"
                            let username = String(email.split(separator: "@").first ?? "")
                            self.username = username
                            reply(LoginData(id: self.userID ?? "", email: username + "@test.com",password: "", username: username, success: true))
                        }
                    }
                }
            case .logout:
                Task{@MainActor in
                    print("logout received from watch")
                    await self.logout()
                    reply(LoginData())
                }
                
            default:
                break
            }
        }
    }
    
    func logout() async{
        print("logout")
        do{
            print("before auth signout")
            try self.auth.signOut()
            print(self.auth.currentUser?.uid ?? "no user")
            print("after auth signout")
            self.username = nil
            self.userID = nil
            self.loggedIn = false
            
        } catch {
            print("Failed to logout \(error)")
        }
    }
    
    func login(email e:String, password p:String) async -> Result<String, Error>{
        print("login authservice")
        
        var status = await authenticate(email: e, password: p)
        
        if case .failure(let error) = status {
            if  let fireError = AuthErrorCode(rawValue: error._code)
            {
                print(error)
                switch fireError {
                case .emailAlreadyInUse:
                    print("email conflict")
                case .wrongPassword:
                    print("bad pass")
                case .userNotFound:
                    print("new user")
                    status = await newUser(email: e, password: p)
                default:
                    print(fireError.rawValue)
                }
            }
        }
        else {
            print("login success authservice")
        }
        
        return status
    }
    
    func update() {
        print("update")
    }
    
    
    func authenticate(email e:String, password p:String) async -> Result<String, Error>{
        do{
            let authResult = try await auth.signIn(withEmail: e, password: p)
            self.userID = authResult.user.uid
            return .success(authResult.user.uid)
        } catch {
            return .failure(error)
        }
    }
    
    func newUser(email e:String, password p:String) async -> Result<String, Error> {
        print("new user")
        print(e)
        do{
            _ = try await auth.createUser(withEmail: e, password: p)
            
            return await login(email: e, password: p)
        } catch {
            if let fireError = AuthErrorCode(rawValue: error._code)
            {
                switch fireError {
                case .emailAlreadyInUse:
                    print("email conflict new")
                    return await login(email: e, password: p)
                default:
                    break
                }
            }
            
            print(error)
            return .failure(error)
        }
    }
    
}
