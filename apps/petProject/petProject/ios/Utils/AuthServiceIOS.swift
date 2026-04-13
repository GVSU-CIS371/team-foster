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


class AuthServiceIOS: ObservableObject, AuthService{
    var userID: String? = "Default"
    
    var loggedIn: Bool
    
    static let shared = AuthServiceIOS()
    
    let auth = Auth.auth()
    let connMan = ConnectionManager.shared
    
    required internal init() {
        self.userID = auth.currentUser?.uid
        self.loggedIn = auth.currentUser != nil
    }
    
    func logout() async{
        print("logout")
        do{
            try auth.signOut()
        } catch {
            print("Failed to logout \(error)")
        }
    }
    
    func login(email e:String, password p:String) async -> Result<String, Error>{
        print("login authservice")
        
        /*connMan.send(message: ["event":"login"], replyHandler: { (reply) in
            if let status = reply["status"] as? String, status == "success"{
                print("AuthService: Login Sent Phone")

            }
        })*/
        
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
