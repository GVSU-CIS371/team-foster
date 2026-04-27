//
//  petProjectApp.swift
//  petProject Watch App
//
//  Created by Aaron Foster on 2/15/26.
//

import SwiftUI

@main
struct petProject_Watch_AppApp: App {
    @StateObject var vm = PetViewModel(dbUtil: DBUtilitiesWatch(), authStatus: AuthServiceWatch.shared)
    init(){
        //let cm = ConnectionManager.shared
        
        /*cm.register(event:"login") { message in
            print("Login Received Watch")
        }
        
        cm.register(event:"logout") { message in
            print("Logout Received Watch")
        }
        
        cm.register(event: "useItem")  { message in
            print("Feed Received Watch")
        }
        
        cm.register(event: "buyItem") { message in
            print("Play Received Watch")
        }
        
        cm.register(event:"pet created") { message in
            print("Pet Created Received Watch")
        }
        
        cm.register(event: "get") { message in
            print("Get Received Watch \(message)")
            
        }*/
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(vm)
        }
    }
}
