//
//  PetViewModel.swift
//  petProject
//
//  Created by Aaron Foster on 3/1/26.
//

import Foundation
import SwiftUI
import Combine

@Observable
class PetViewModel: ObservableObject {
    private(set) var name: String = "Default Name"
    
    func setName(_ name: String) {
        self.name = name
    }
    
}
