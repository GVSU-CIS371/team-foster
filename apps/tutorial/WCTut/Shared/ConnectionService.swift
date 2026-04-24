//
//  ConnectionService.swift
//  WCTut
//
//  Created by Aaron Foster on 4/20/26.
//

import Foundation
import WatchConnectivity

enum ActionType: String, Codable {
    case create
    case read
    case update
    case delete
    case success
    case failure
    case none
}

class ConnectionService: NSObject, WCSessionDelegate {
    struct MessageDataEnvelope: Codable {
        let type: String
        let action: ActionType
        let payload: Data
    }
    
    static let shared = ConnectionService()
    private let session = WCSession.default

    private override init() {
        super.init( )
        startSession()
    }
    
    func encode(data: any Codable, action: ActionType = .none) -> Data?{
        let objData = try? JSONEncoder().encode(data)
        let envelope = MessageDataEnvelope(type: String(describing: type(of: data)), action: action, payload: objData!)
        let data = try? JSONEncoder().encode(envelope)
        
        return data
    }

    
    private var handlers: [String: ([String: Any], @escaping ([String: Any])->Void) -> Void] = [:]

    func register(event: String, handler: @escaping ([String: Any], @escaping ([String: Any]) -> Void) -> Void) {
        handlers[event] = handler
    }


    private var dataHandlers: [String: (Data, ActionType, @escaping (Data) -> Void) -> Void] = [:]
        
    func registerData<T: Codable>(type: T.Type, action: ActionType = .none, handler: @escaping (T, ActionType, @escaping (T) -> Void) -> Void) {
        let type = String(describing: T.self)
        dataHandlers[type] = { rawData, action, reply in
            guard let decoded = try? JSONDecoder().decode(T.self, from: rawData) else {return}
            handler(decoded, action) { replyData in
                guard let encodedData = self.encode(data: replyData, action: action) else {return}
                reply(encodedData)
            }
        }
    }
    
    func startSession() {
        print("Starting Session")
        guard WCSession.isSupported() else {return}
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {print("Activation error: \(error)")}
        print("Activated session")
    }

    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void){
        print("MESSAGE DELEGATE")
        
        guard let event = message["event"] as? String else { replyHandler(message); return}
        guard let handler = handlers[event] else {replyHandler(message); return}
        handler(message) { reply in
            replyHandler(reply)
        }
    }
    
    
    func session(_ session: WCSession, didReceiveMessageData data: Data, replyHandler: @escaping (Data) -> Void) {
        print("MESSAGE DATA DELEGATE")
        
        guard let decoded = try? JSONDecoder().decode(MessageDataEnvelope.self, from: data) else {replyHandler(data); return}
        guard let handler = dataHandlers[decoded.type] else {replyHandler(data); return}
        handler(decoded.payload, decoded.action) { replyData in
            replyHandler(replyData)
        }
    }
    
    
    func send(message: [String: Any], replyHandler: (([String: Any]) -> Void)? = nil) {
        print("SEND MESSAGE")
        guard session.isReachable else { replyHandler?(message); return }
        session.sendMessage(message, replyHandler: { reply in
            replyHandler?(reply)
        })
    }
    
 
    
    func sendData(data: any Codable, action: ActionType = .none, replyHandler: ((Data) -> Void)? = nil) {
        print("SEND DATA")
        guard session.isReachable else {return}
        do{
            let objData = try JSONEncoder().encode(data)
            let envelope = MessageDataEnvelope(type: String(describing: type(of: data)), action: action, payload: objData)
            let encoded = try JSONEncoder().encode(envelope)
            session.sendMessageData(encoded, replyHandler: { replyData in
                replyHandler?(replyData)
            })
        } catch(let error){
            print(error)
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

