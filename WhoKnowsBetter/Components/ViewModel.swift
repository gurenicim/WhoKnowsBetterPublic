//
//  ViewModel.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 17.03.2023.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var showError = false
    var errorMessage = ""

   func showError(message: String) {
        errorMessage = message
        showError = true
    }

}
