//
//  OptionsView.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import SwiftUI

struct OptionsView: View {
    private var onLogout: () -> Void
    
    init(onLogout: @escaping () -> Void){
        self.onLogout = onLogout
    }
    
    var body: some View{
        Text("Options")
        
        Button("Logout"){
            self.onLogout()
        }.padding().clipShape(Capsule()).border(Color.white)
    }
}
