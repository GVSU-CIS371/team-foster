//
//  AuthStatus.swift
//  petProject
//
//  Created by Aaron Foster on 3/31/26.
//
import SwiftUI

protocol AuthService {
    var userID: String? { get }
    var loggedIn: Bool { get }
    
    init()
    func logout() async
    func login(email: String, password: String) async -> Result<String, Error>
    func update() async
    func newUser(email: String, password: String) async -> Result<String, Error>
}
