//
//  IncomingRequestsPage.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 19.04.2023.
//

import SwiftUI

struct FriendListPage: View {
    @EnvironmentObject var player: Player
    @State var aList: Array<String> = []
    
    @ViewBuilder
    func InfoContainer(title: String, color: Color, image: String)->some View {
        HStack {
            Image(systemName: image)
                .font(.title2)
                .foregroundColor(color)
                .padding(10)
                .background(
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        
                        Circle()
                            .stroke(color, lineWidth: 2)
                    }
                )
            
            Text(title)
                .font(.title2.bold())
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var body: some View {
        List {
            ForEach(aList, id: \.self) { usr in
                HStack {
                    InfoContainer(title: usr, color: .yellow, image: "person.crop.circle")
                    Spacer()
                }
            }.listRowBackground(Color.clear)
        }.scrollContentBackground(.hidden).navigationTitle("Your Friends")
            .onAppear {
                aList = player.friendList
                player.updateFriendshipFromDatabase()
            }
    }
}

