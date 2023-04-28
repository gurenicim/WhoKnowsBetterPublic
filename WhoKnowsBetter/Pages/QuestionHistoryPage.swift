//
//  QuestionHistoryPage.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 14.04.2023.
//

import SwiftUI

struct QuestionHistoryPage: View {
    
    @Binding var presentSideMenu: Bool
    @EnvironmentObject var player: Player
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            
            Spacer()
            Text("History will be showed").font(.title)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
