//
//  petProjectApp.swift
//  petProject
//
//  Created by Aaron Foster on 2/15/26.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()
      
    return true

  }

}

@main
struct petProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let cm = ConnectionManager.shared
    

    @StateObject var vm = PetViewModel(dbUtil: DBUtilitiesIOS(), authStatus: AuthServiceIOS())
    
    init(){
        cm.register(event:"login") { message in
            print("Login Received Phone @main}")
            
        }
        
        cm.register(event:"logout") { message in
            print("Logout Received Phone @main")
        }
        
        cm.register(event: "use")  { message in
            print("Feed Received Phone @main")
        }
        
        cm.register(event: "buy") { message in
            print("Play Received Phone @main")
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(vm)
        }
    }
}
