//
//  AppFlowView.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 28.04.2023.
//

import SwiftUI
import Firebase
import FirebaseMessaging

struct AppFlowView: View {
    @ObservedObject var player: Player = Player(userDefaults: UserDefaults.standard)
    @ObservedObject var isQuizReceived: QuizBooleanDelegateSwitch = QuizBooleanDelegateSwitch.shared
    @ObservedObject var quiz: Quiz = Quiz.shared
    
    func fetchUserData() {
        let db = Firestore.firestore()
        Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true) {
            (authResult, err) in
            if let err = err {
                print("Error: \(err)")
                try? Auth.auth().signOut()
            } else if (authResult == nil) {
                try? Auth.auth().signOut()
            }
        }
        let email = Auth.auth().currentUser?.email
        db.collection("players").whereField("email", isEqualTo: email!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let defaults = UserDefaults.standard
                        let username = document.data()["username"] as! String
                        defaults.set(document.data(), forKey: "userProfile")
                        defaults.set(username, forKey: "username")
                    }
                }
            }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    DashBoardPage(player: player).frame(minHeight: geometry.size.height)
                }.frame(width: geometry.size.width)
                    .refreshable {
                    DispatchQueue.main.async {
                        fetchUserData()
                        let updatedPlayer = Player(userDefaults: UserDefaults.standard)
                        player.updateInfoAndStats(updatedPlayer: updatedPlayer)
                    }
                    }.onAppear {
                        DispatchQueue.main.async {
                            fetchUserData()
                            let updatedPlayer = Player(userDefaults: UserDefaults.standard)
                            player.updateInfoAndStats(updatedPlayer: updatedPlayer)
                        }
                    }
            }
            QuizViewPage(isNewQuizReceived: $isQuizReceived.isTodaysQuizReceived, player: player, questionArray: quiz.questionArray)
        }
    }
}
