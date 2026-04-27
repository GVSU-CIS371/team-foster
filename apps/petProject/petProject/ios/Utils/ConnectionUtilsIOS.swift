//
//  ConnectionUtilsIOS.swift
//  petProject
//
//  Created by Aaron Foster on 4/5/26.
//

class ConnectionUtilsIOS: ConnectionUtilities {
    
    func eventConnectionHandler(data: [String: Any]){
        switch data.first!.key {
        case "login":
            print("Successfully logged in")
            
        case "logout":
            print("Successfully logged out")
        case "createPet":
            print("Successfully created pet")
        default:
            print("unknown event")
        }
    }
    
    
    
    func updateConnectionHandler(data: [String: Any]){
        switch data.first!.key {
        case "pet":
            print("Pet updated")
        case "inventory":
            print("Inventory updated")
        case "inventoryItem":
            print("Inventory item updated")
        case "petType":
            print("Pet type updated")
        case "shopType":
            print("shop type updated")
        case "shopItem":
            print("shop item updated")
        case "player":
            print("player updated")
        
        default:
            print("unknown update")
        }
    }
    
    func getConnectionHandler(data: [String: Any]){
        switch data.first!.key {
        case "pet":
            print("Pet retrieved")
        case "inventory":
            print("Inventory retrieved")
        case "inventoryItem":
            print("Inventory item retrieved")
        case "petType":
            print("Pet type retrieved")
        case "shop":
            print("shop retrieved")
        case "shopItem":
            print("shop item retrieved")
        case "player":
            print("player retrieved")
            
        default:
            print("unknown get")
            
        }
    }
    
    func buyConnectionHandler(data: [String: Any]){
        print("Successfully bought item")
    }
    
    func tickConnectionHandler(data: [String: Any]){
        print("Tick received")
    }
    
    func useConnectionHandler(data: [String: Any]){
        print("Successfully used item")
    }
    
    func rmvConnectionHandler(data: [String : Any]) {
        print("Successfully removed item")
    }
    
    func addConnectionHandler(data: [String : Any]) {
        print("Successfully added item")
    }
    
    
}
