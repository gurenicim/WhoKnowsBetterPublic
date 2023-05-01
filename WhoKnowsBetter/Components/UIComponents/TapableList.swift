//
//  TapableList.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 22.03.2023.
//

import SwiftUI

struct TapableList: View {
    @State private var selectedIndex: String?
    @Binding var userList: Array<String>
    @EnvironmentObject var player: Player
    @Binding var buttonText: String
    var body: some View {
        VStack {
            List {
                ForEach(userList, id: \.self) { usr in
                    HStack {
                        Text("\(usr)")
                        Spacer()
                        Text((player.friendList.contains(usr) || player.outgoingFriendRequests.contains(usr)) ? "Added": "Add").foregroundColor(.blue)
                    }.contentShape(Rectangle()).onTapGesture {
                        selectedIndex = usr
                        player.sendFriendRequestTo(friendUsername: "\(usr)")
                        buttonText = "Added"
                    }.disabled(buttonText=="Added")
                }.listRowBackground(Color.yellow)
            }.scrollContentBackground(.hidden)
        }
    }
}
