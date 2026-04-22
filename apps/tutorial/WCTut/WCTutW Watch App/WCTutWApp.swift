//
//  WCTutWApp.swift
//  WCTutW Watch App
//
//  Created by Aaron Foster on 4/20/26.
//

import SwiftUI

@main
struct WCTutW_Watch_AppApp: App {
    var vm = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
        }
    }
}
