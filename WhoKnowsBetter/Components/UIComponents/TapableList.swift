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
    @EnvironmentObject var selfPlayer: Player
    @Binding var buttonText: String
    var body: some View {
        VStack {
            List {
                ForEach(userList, id: \.self) { usr in
                    HStack {
                        Text("\(usr)")
                        Spacer()
                        Text(buttonText).foregroundColor(.blue)
                    }.contentShape(Rectangle()).onTapGesture {
                        selectedIndex = usr
                        selfPlayer.sendFriendRequestTo(friendUsername: "\(usr)")
                        buttonText = "Added"
                    }
                }.listRowBackground(Color.yellow)
            }.scrollContentBackground(.hidden)
        }
    }
}
