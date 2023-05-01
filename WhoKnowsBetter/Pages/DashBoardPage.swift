//
//  DashBoardPage.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 20.03.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseMessaging

struct DashBoardPage: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isNewQuizReceived: Bool = false
    @State private var isUserLoggedIn: Bool = true
    @State var searchString = ""
    @State var userArray: Array<[String:Any]> = [[String:Any]]()
    @State var userList: Array<String> = [String]()
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @EnvironmentObject var isTodaysQuestionReceived: QuizBooleanDelegateSwitch
    @ObservedObject var player: Player
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    func searchForFriend(username: String){
        
        let docRef = db.collection("players").document(username)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                userList = [document.data()!["username"] as! String]
            } else {
                userList.removeAll()
            }
        }
    }
    
    var content: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedSideMenuTab) {
                    ProfilePage(presentSideMenu: $presentSideMenu, player: player).tag(0)
                    FriendshipPage(searchString: $searchString, userList: $userList, presentSideMenu: $presentSideMenu, player: player, isUserLoggedIn: $isUserLoggedIn).tag(1)
                    QuestionHistoryPage(presentSideMenu: $presentSideMenu).tag(2)
                }.tabViewStyle(.page(indexDisplayMode: .never))
                SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
            }.onAppear {
                #if !targetEnvironment(simulator)
                if !defaults.bool(forKey: "isNotifTokenRegisteredBefore") {
                    let dict = ["username" : defaults.string(forKey: "username"),
                                "notifToken" : Messaging.messaging().fcmToken]
                    db.collection("notifTokens").document(defaults.string(forKey: "username") ?? "-1").setData(dict as [String : Any])
                    defaults.set(true, forKey: "isNotifTokenRegisteredBefore")
                }
                #endif
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        isUserLoggedIn = true
                        isNewQuizReceived = defaults.bool(forKey: "isNewQuizReceived")
                    } else {
                        isUserLoggedIn = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }.navigationBarBackButtonHidden()
        }
    }
    
    var body: some View {
        ZStack {
            content
        }
    }
}


