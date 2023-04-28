//
//  Player.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 8.03.2023.
//

import Foundation
import Firebase

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

class Player: Codable, ObservableObject{
    
    enum CodingKeys: String, CodingKey {
        case username
        case name
        case surname
        case email
        case passCount
        case point
        case rank
        case correctAnswerCount
        case wrongAnswerCount
        case friendList
        case incomingFriendRequests
        case outgoingFriendRequests
    }
    
    var username: String
    var name: String
    var surname: String
    var email: String
    @Published var passCount: Int
    @Published var point: Int
    @Published var rank: Int
    @Published var correctAnswerCount: Int
    @Published var wrongAnswerCount: Int
    @Published var friendList: Array<String>
    @Published var incomingFriendRequests: Array<String>
    @Published var outgoingFriendRequests: Array<String>
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decode(String.self, forKey: .username)
        name = try values.decode(String.self, forKey: .name)
        surname = try values.decode(String.self, forKey: .surname)
        email = try values.decode(String.self, forKey: .email)
        passCount = try values.decode(Int.self, forKey: .passCount)
        point = try values.decode(Int.self, forKey: .point)
        rank = try values.decode(Int.self, forKey: .rank)
        correctAnswerCount = try values.decode(Int.self, forKey: .correctAnswerCount)
        wrongAnswerCount = try values.decode(Int.self, forKey: .wrongAnswerCount)
        friendList = try values.decode(Array.self, forKey: .friendList)
        incomingFriendRequests = try values.decode(Array.self, forKey: .incomingFriendRequests)
        outgoingFriendRequests = try values.decode(Array.self, forKey: .outgoingFriendRequests)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
    }
    
    init(username: String, name: String, surname: String, email: String, passCount: Int, point: Int, rank: Int, correctAnswerCount: Int, wrongAnswerCount: Int, friendList: Array<String>, incomingFriendRequests: Array<String>, outgoingFriendRequests: Array<String>) {
        self.username = username
        self.name = name
        self.surname = surname
        self.email = email
        self.passCount = passCount
        self.point = point
        self.rank = rank
        self.correctAnswerCount = correctAnswerCount
        self.wrongAnswerCount = wrongAnswerCount
        self.friendList = friendList
        self.incomingFriendRequests = incomingFriendRequests
        self.outgoingFriendRequests = outgoingFriendRequests
    }
    
    init(dict: [String:Any]) {
        self.username = dict["username"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.surname = dict["surname"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.passCount = dict["passCount"] as? Int ?? 0
        self.point = dict["point"] as? Int ?? 0
        self.rank = dict["rank"] as? Int ?? 0
        self.correctAnswerCount = dict["correctAnswerCount"] as? Int ?? 0
        self.wrongAnswerCount = dict["wrongAnswerCount"] as? Int ?? 0
        self.friendList = dict["friendList"] as? Array<String> ?? []
        self.incomingFriendRequests = dict["incomingFriendRequests"] as? Array<String> ?? []
        self.outgoingFriendRequests = dict["outgoingFriendRequests"] as? Array<String> ?? []
    }
    
    init(userDefaults: UserDefaults) {
        self.username = userDefaults.dictionary(forKey: "userProfile")?["username"] as? String ?? ""
        self.name = userDefaults.dictionary(forKey: "userProfile")?["name"] as? String ?? ""
        self.surname = userDefaults.dictionary(forKey: "userProfile")?["surname"] as? String ?? ""
        self.email = userDefaults.dictionary(forKey: "userProfile")?["email"] as? String ?? ""
        self.passCount = userDefaults.dictionary(forKey: "userProfile")?["passCount"] as? Int ?? 0
        self.point = userDefaults.dictionary(forKey: "userProfile")?["point"] as? Int ?? 0
        self.rank = userDefaults.dictionary(forKey: "userProfile")?["rank"] as? Int ?? 0
        self.correctAnswerCount = userDefaults.dictionary(forKey: "userProfile")?["correctAnswerCount"] as? Int ?? 0
        self.wrongAnswerCount = userDefaults.dictionary(forKey: "userProfile")?["wrongAnswerCount"] as? Int ?? 0
        self.friendList = userDefaults.dictionary(forKey: "userProfile")?["friendList"] as? Array<String> ?? []
        self.incomingFriendRequests = userDefaults.dictionary(forKey: "userProfile")?["incomingFriendRequests"] as? Array<String> ?? []
        self.outgoingFriendRequests = userDefaults.dictionary(forKey: "userProfile")?["outgoingFriendRequests"] as? Array<String> ?? []
    }
    
    func encode() -> [String: Any] {
        guard let dict = try? self.asDictionary() else { return [String:Any]() }
        return dict
    }
    
    func updateUserProfile() {
        try? UserDefaults.standard.set(self.asDictionary(), forKey: "userProfile")
    }
    
    func updateStats() {
        let db = Firestore.firestore()
        let currentUser = db.collection("players").document(username)
        currentUser.updateData([
            "point": point,
            "correctAnswerCount": correctAnswerCount,
            "wrongAnswerCount": wrongAnswerCount,
            "passCount": passCount
        ])
        updateUserProfile()
    }
    
    func sendFriendRequestTo(friendUsername: String) {
        if !outgoingFriendRequests.contains(friendUsername) && !friendList.contains(friendUsername) {
            outgoingFriendRequests.append(friendUsername)
            let db = Firestore.firestore()
            let currentUser = db.collection("players").document(username)
            let friend = db.collection("players").document(friendUsername)
            
            currentUser.updateData([
                "outgoingFriendRequests": FieldValue.arrayUnion([friendUsername])
            ])
            friend.updateData([
                "incomingFriendRequests": FieldValue.arrayUnion([username])
            ])
        }
        updateUserProfile()
    }
    
    func acceptFriendRequest(friendUsername: String) {
        if incomingFriendRequests.contains(friendUsername) && !friendList.contains(friendUsername){
            friendList.append(friendUsername)
            incomingFriendRequests.remove(at: incomingFriendRequests.firstIndex(of: friendUsername)!)
            
            let db = Firestore.firestore()
            let currentUser = db.collection("players").document(username)
            let friend = db.collection("players").document(friendUsername)
            
            currentUser.updateData([
                "friendList": FieldValue.arrayUnion([friendUsername])
            ])
            friend.updateData([
                "friendList": FieldValue.arrayUnion([username])
            ])
            currentUser.updateData([
                "incomingFriendRequests": FieldValue.arrayRemove([friendUsername])
            ])
            friend.updateData([
                "outgoingFriendRequests": FieldValue.arrayRemove([username])
            ])
        }
        updateUserProfile()
    }
    
    func declineFriendRequest(friendUsername: String) {
        if incomingFriendRequests.contains(friendUsername) && !friendList.contains(friendUsername){
            incomingFriendRequests.remove(at: incomingFriendRequests.firstIndex(of: friendUsername)!)
            
            let db = Firestore.firestore()
            let currentUser = db.collection("players").document(username)
            let friend = db.collection("players").document(friendUsername)
            
            currentUser.updateData([
                "incomingFriendRequests": FieldValue.arrayRemove([friendUsername])
            ])
            friend.updateData([
                "outgoingFriendRequests": FieldValue.arrayRemove([username])
            ])
        }
        updateUserProfile()
    }
    
    func removeFriend(friendUsername: String) {
        if friendList.contains(friendUsername){
            friendList.remove(at: friendList.firstIndex(of: friendUsername)!)
            
            let db = Firestore.firestore()
            let currentUser = db.collection("players").document(username)
            let friend = db.collection("players").document(friendUsername)
            
            currentUser.updateData([
                "friendList": FieldValue.arrayRemove([friendUsername])
            ])
            friend.updateData([
                "friendList": FieldValue.arrayRemove([username])
            ])
        }
        updateUserProfile()
    }
    
    func unsendFriendRequest(friendUsername: String) {
        if outgoingFriendRequests.contains(friendUsername) && !friendList.contains(friendUsername) {
            outgoingFriendRequests.remove(at: outgoingFriendRequests.firstIndex(of: friendUsername)!)
            
            let db = Firestore.firestore()
            let currentUser = db.collection("players").document(username)
            let friend = db.collection("players").document(friendUsername)
            
            currentUser.updateData([
                "outgoingFriendRequests": FieldValue.arrayRemove([friendUsername])
            ])
            friend.updateData([
                "incomingFriendRequests": FieldValue.arrayRemove([username])
            ])
        }
        updateUserProfile()
    }
}
