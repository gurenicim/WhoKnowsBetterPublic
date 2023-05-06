//
//  ProfilePage.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 12.04.2023.
//

import SwiftUI
import Firebase

struct ProfilePage: View {
    
    @Binding var presentSideMenu: Bool
    @ObservedObject var player: Player
    
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
            Spacer().frame(width: 0, height: 32)
            VStack {
                HStack {
                    VStack {
                        Text("Your Profile")
                            .font(.title.bold())
                        Divider().frame(width: 200)
                    }
                    Spacer()
                }
                
                Spacer().frame(width: 0, height: 32)
                InfoContainer(title: "Point", color: .blue, image: "flag.checkered", progress: CGFloat(player.point))
                Spacer()
                InfoContainer(title: "Correct Answer", color: .green, image: "checkmark.circle", progress: CGFloat(player.correctAnswerCount))
                Spacer()
                InfoContainer(title: "Pass Count", color: .gray, image: "p.circle", progress: CGFloat(player.passCount))
                Spacer()
                InfoContainer(title: "Wrong Answer", color: .red, image: "x.circle", progress: CGFloat(player.wrongAnswerCount))
                Spacer()
            }
            Spacer()
        }
        .padding(24)
    }
}
