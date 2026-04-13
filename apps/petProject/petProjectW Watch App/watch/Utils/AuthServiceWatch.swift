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

extension AuthService {
    func login(username: String, password: String) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation{ continuation in
            ConnectionManager.shared.send(message: [ConnectionEventType.event.rawValue:"login"], replyHandler: { (reply) in
                if let status = reply["status"] as? String, status == "success"{
                    print("Login Received From iOS")
                    let userID = self.userID ?? "Default"
                    continuation.resume(returning: reply)
                }
                else{
                    continuation.resume(throwing: AuthStatus.failure)
                }
            })
        
        }
    }
}

class AuthServiceWatch: ObservableObject, AuthService{
    required init() {
        <#code#>
    }
    
    func logout() async {
        <#code#>
    }
    
    func update() async {
        <#code#>
    }
    
    func newUser(email: String, password: String) async -> Result<String, any Error> {
        <#code#>
    }
    
    var userID: String? = "Default"
    
    var loggedIn: Bool
        
    func login(email: String, password: String) async -> Result<String, any Error> {

    
    static var shared: AuthServiceWatch = .init()
    var loggedIn: Bool
    var lastLogin: Date?
    
    required init() {
        self.loggedIn = false
        self.lastLogin = nil
        
    }
    
    func login (username: String, password: String, loggedIn: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func newUser(email: String, password: String) async -> Result<String, any Error> {
        print("new user")
        return .success("")
    }
    
    var userID: String?
    
    func logout() {
        print("logout")
    }

    
    func update() {
        print("update")
    }
}
