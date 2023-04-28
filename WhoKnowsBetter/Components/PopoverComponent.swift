//
//  PopoverComponent.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 3.03.2023.
//

import Foundation
import SwiftUI

struct PopoverModel: Identifiable {
    var id: String { message }
    let message: String
    
    init(message: String) {
        self.message = message
    }
}
