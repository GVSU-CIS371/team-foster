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
    case command //get, user, buy, update, add, rmv
    case tick
}

class ConnectionManager: NSObject, WCSessionDelegate {

    
    static let shared = ConnectionManager()
    private let session = WCSession.default
    
    var onPlayerUpdate: ((Player) -> Void)?
    var onPetUpdate: ((Pet) -> Void)?
    var onInventoryUpdate: ((Inventory) -> Void)?
    var onInvItemUpdate: ((InventoryItem) -> Void)?
    var onShopUpdate: ((Shop) -> Void)?
    var onShopItemUpdate: ((ShopItem) -> Void)?
    
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
    
    private var handlers: [String: ([String: Any], @escaping ([String: Any])->Void) -> Void] = [:]
    
    func register(event: String, handler: @escaping ([String: Any], @escaping ([String: Any]) -> Void) -> Void) {
        handlers[event] = handler
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void){
        guard let event = message["event"] as? String else {
            replyHandler([:])
            return
        }
        
        Task{ @MainActor in
            if let handler = self.handlers[event] {
                handler(message, replyHandler)
            } else
            {
                replyHandler(["error":"no handler"])
            }
        }
    }
    
    
    func send(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        guard session.isReachable else {
            print("cannot reach target")
            return}
        session.sendMessage(message, replyHandler: replyHandler)
    }
    
    

    private var dataHandlers: [String: (Data, ActionType, @escaping (Data) -> Void) -> Void] = [:]
    
    func registerData<T: Codable>(type: T.Type, handler: @escaping (T, ActionType, @escaping (T) -> Void) -> Void) {
        let typeName = String(describing: T.self)
        dataHandlers[typeName] = {rawData, action, reply in
            print("rawData ", rawData)
            print("RAW STRING:", String(data: rawData, encoding: .utf8) ?? "nil")
   
            guard let decoded = try? JSONDecoder().decode(T.self, from: rawData) else {
                print("failed to decode specified type")
                return
            }
            
            handler(decoded, action) { replyData in
                print("Handler")
                print("Decoded", decoded)
                print("Action", action)
                print("DATA", replyData)
                    guard let payload = try? JSONEncoder().encode(replyData),
                          let encodedMsg = try? JSONEncoder().encode(EncodedMessage(type: typeName, action: action, payload: payload)) else {return}
                
                print("encoded ", encodedMsg)
                reply(encodedMsg)
            }
        }
    }
    
    
    func sendData(data: any Codable, action: ActionType = .none, replyHandler: @escaping (Data) -> Void) {
        guard session.isReachable else {
            print("cannot reach target")
            return}
        do{
            let objData = try JSONEncoder().encode(data)
            let rawData = EncodedMessage(type: String(describing: type(of: data)), action: action, payload: objData)
            let data = try JSONEncoder().encode(rawData)
            session.sendMessageData(data) { replyData in
                replyHandler(replyData)
                print("Send Data", replyData)
            }
            
        } catch {
            print("Error Encoding")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData data: Data, replyHandler: @escaping (Data) -> Void) {
        guard session.isReachable else {return}
        do{
            let decoded = try JSONDecoder().decode(EncodedMessage.self, from: data)
            if let handler = dataHandlers[decoded.type] {
                print("session handler")
                handler(decoded.payload, decoded.action, replyHandler)
            } else {
                print ("No handler for \(decoded.type)")
                replyHandler(Data())
            }
            
            print("Data Session Receieved \(decoded)")
            
        }catch{
            print("Decode Error")
        }
    }
    
    struct EncodedMessage: Codable {
        let type: String
        let action: ActionType
        let payload: Data
    }
    
    enum ActionType: String, Codable {
        case get
        case add
        case update
        case none
        case login
        case logout
    }
    

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {print("Activation error: \(error)")}
        print("Activated session")
    }

    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        print("Activated session")
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

