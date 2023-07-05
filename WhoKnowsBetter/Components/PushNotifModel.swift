//
//  PushNotifModel.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 29.04.2023.
//

import Foundation

class PushNotifModel: ObservableObject {
    static let shared: PushNotifModel = PushNotifModel()
    @Published var notifMessage: String = String()
    @Published var isFriendRequest: Bool = false
    @Published var isRemoveFriend: Bool = false
    @Published var isDecline: Bool = false
}
