//
//  ConnectionUtilitiess.swift
//  petProject
//
//  Created by Aaron Foster on 4/6/26.
//

protocol ConnectionUtilities {
    func eventConnectionHandler(data: [String: Any])
    func updateConnectionHandler(data: [String: Any])
    func getConnectionHandler(data: [String: Any])
    func buyConnectionHandler(data: [String: Any])
    func tickConnectionHandler(data: [String: Any])
    func useConnectionHandler(data: [String: Any])
    func addConnectionHandler(data: [String: Any])
    func rmvConnectionHandler(data: [String: Any])
}
