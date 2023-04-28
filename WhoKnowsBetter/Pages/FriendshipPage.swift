//
//  FriendshipPage.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 12.04.2023.
//

import SwiftUI
import Firebase

struct FriendshipPage: View {
    @Binding var searchString: String
    @Binding var userList: Array<String>
    @Binding var presentSideMenu: Bool
    @ObservedObject var player: Player
    @Binding var isUserLoggedIn: Bool
    @FocusState var isFocused: Bool
    @State var buttonText: String = "Add"
    @State var incomingCount: Int = 0
    @State var friendCount: Int = 0
    
    @ViewBuilder
    func InfoContainer(title: String, color: Color, image: String, progress: CGFloat)->some View {
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
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(Int(progress))")
                    .font(.title2.bold())
                
                Text(title)
                    .font(.caption2.bold())
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
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
    
    func searchForFriend(username: String){
        let db = Firestore.firestore()
        let docRef = db.collection("players").document(username)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                userList = [document.data()!["username"] as! String]
            } else {
                userList.removeAll()
            }
        }
    }
    
    var body: some View {
        VStack (spacing: 16){
            HStack {
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }.onTapGesture {
                isFocused = false
            }
            HStack {
                VStack {
                    Text("Friends Hub")
                        .font(.title.bold())
                    Divider().frame(width: 200)
                }
                Spacer()
            }.onTapGesture {
                isFocused = false
            }
            Spacer().frame(height: 20).onTapGesture {
                isFocused = false
            }
            HStack {
                NavigationLink(destination: FriendListPage().environmentObject(player) ) {
                    InfoContainer(title: "Friends", color: .yellow, image: "person.3", progress: CGFloat(friendCount))
                }
                Spacer()
                NavigationLink(destination: IncomingRequestsPage().environmentObject(player)) {
                    InfoContainer(title: "Requests", color: .yellow, image: "person.crop.circle.badge.clock", progress: CGFloat(incomingCount))
                }
            }.onTapGesture {
                isFocused = false
            }
            Spacer().frame(height: 20).onTapGesture {
                isFocused = false
            }
            SearchBar(searchString: $searchString, isFocused: _isFocused, placeHolder: "Search for a friend...")
            Button("Search") {
                if (!searchString.isEmpty && searchString != player.username) {
                    searchForFriend(username: searchString)
                    if !userList.isEmpty && player.friendList.contains(userList.first ?? "-1") && player.outgoingFriendRequests.contains(userList.first ?? "-1") {
                        buttonText = "Added"
                    }
                } else {
                    userList.removeAll()
                }
            }
            TapableList(userList: $userList, buttonText: $buttonText).onTapGesture {
                isFocused = false
            }
        }.onAppear {
            friendCount = player.friendList.count
            incomingCount = player.incomingFriendRequests.count
            
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    isUserLoggedIn = true
                } else {
                    isUserLoggedIn = false
                }
            }
        }.navigationBarBackButtonHidden().padding(24).refreshable {
            fetchUserData()
        }
        
    }
}
