//
//  ContentView.swift
//  WCTutW Watch App
//
//  Created by Aaron Foster on 4/20/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ViewModel
    @StateObject private var navCtrl = Navigator()
    
    init(vm: ViewModel){
        self._vm = ObservedObject(wrappedValue: vm)

    }
    
    var body: some View {
        NavigationStack(path: $navCtrl.navPath) {
            MainMenu(){
                navCtrl.navigate(to: .SendMessageView)
            } sendMsgData: {
                navCtrl.navigate(to: .SendDataView)
            } waitToReceive: {
                navCtrl.navigate(to: .WaitView)
            }
            .navigationDestination(for: Route.self) { dest in
                switch dest{
                case .SendDataView:
                    SendDataView(){ data in
                        vm.sendData(data: data)
                        navCtrl.navigate(to: .ReceiveDataView)
                    }
                    
                case .SendMessageView:
                    SendMessageView(){ msg in
                        vm.sendMessage(data: msg)
                        navCtrl.navigate(to: .ReceiveMessageView)
                    }
                    
                case .ReceiveDataView:
                    ReceiveDataView(vm: vm)
                    
                case .ReceiveMessageView:
                    ReceiveMessageView(vm: vm)
                    
                case .WaitView:
                    WaitView(vm: vm)
                }
            }
        }
        .ignoresSafeArea(edges:.all)
    }
}

