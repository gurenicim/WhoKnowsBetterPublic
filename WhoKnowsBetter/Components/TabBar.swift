//
//  TabBar.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 21.03.2023.
//

import Foundation
import SwiftUI

struct CustomTabBarItem: View {
    let iconName: String
    let label: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: iconName)
                .frame(minWidth: 25, minHeight: 25) // 1
            Text(label)
                .font(.caption)
        }
        .padding([.top, .bottom], 5) // 2
        .foregroundColor(.blue)
        .frame(maxWidth: .infinity)
    }
}
