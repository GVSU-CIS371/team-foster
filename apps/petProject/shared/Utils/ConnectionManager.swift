//
//  ConnectionManager.swift
//  petProject
//
//  Created by Aaron Foster on 3/30/26.
//

import Foundation
import WatchConnectivity

enum ConnectionEventType: String {
    case status
    case event // login, logout, createPet,
    case get
    case use
    case buy
    case tick
    case update
    case add
    case rmv
}

class ConnectionManager: NSObject, WCSessionDelegate {

    
    static let shared = ConnectionManager()
    private let session = WCSession.default
    
    private override init() {
        super.init( )
        startSession()
    }
    
    func startSession() {
        print("Starting Session")
        guard WCSession.isSupported() else {return}
        session.delegate = self
        session.activate()
    }
    
    private var handlers: [String: ([String: Any]) -> Void] = [:]
    
    func register(event: String, handler: @escaping ([String: Any]) -> Void) {
        handlers[event] = handler
        
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void){
        guard let event = message["event"] as? String else {
            replyHandler([:])
            return
        }
        
        Task{ @MainActor in
            if let handler = self.handlers[event] {
                handler(message)
                replyHandler(["status": "success"])
            } else
            {
                replyHandler([:])
            }
        }
    }
    
    
    func send(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        guard session.isReachable else {return}
        session.sendMessage(message, replyHandler: replyHandler)
    }
    
    
    func sendData(object: any Codable, replyHandler: @escaping (Data) -> Void) {
        guard session.isReachable else {return}
        do{
            let objData = try JSONEncoder().encode(object)
            let rawData = EncodedMessage(type: String(describing: type(of: object)), payload: objData)
            let data = try JSONEncoder().encode(rawData)
            session.sendMessageData(data) { replyData in
                print("Send Data")
            }
            
        } catch {
            print("Error Encoding")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData data: Data, replyHandler: @escaping (Data) -> Void) {
        guard session.isReachable else {return}
        do{
            let item = try JSONDecoder().decode(EncodedMessage.self, from: data)
            print("Receieved \(item.type)")
            
        }catch{
            print("Decode Error")
        }
    }
    
    struct EncodedMessage: Codable {
        let type: String
        let payload: Data
    }
    

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {print("Activation error: \(error)")}
        print("Activated session")
    }

    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        print("Activated session")
    }
    
    func encode<T: Codable>( data: T) throws -> [String: Any] {
        do{
            let json = try JSONEncoder().encode(data)
            let encoded = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] ?? [:]
            
            return encoded
        } catch {
            throw error
        }
    }
    
    func decode<T: Codable>( data: [String:Any]) throws -> T {
        do{
            let json = try JSONSerialization.data(withJSONObject: data, options: [])
            let decoded = try JSONDecoder().decode(T.self, from: json)
            
            return decoded
        }
    }

    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Inactive session")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("Deactivated session")
    }
    #endif
}

