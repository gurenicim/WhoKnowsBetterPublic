//
//  SignUpPage.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 3.03.2023.
//

import Foundation
import SwiftUI
import Firebase

struct SignUpPage : View {
    @FocusState var isInputActive: Bool
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rePassword: String = ""
    @State private var isPresented: Bool = false
    @State private var isUsernameExist: Bool = false
    @Binding var isUserLoggedIn: Bool
    @StateObject var vm = ViewModel()
    
    func baseEncoder(str: String) -> String {
        let utf8str = str.data(using: .utf8)

        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
            print("Encoded: \(base64Encoded)")

            if let base64Decoded = Data(base64Encoded: base64Encoded, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
                // Convert back to a string
                print("Decoded: \(base64Decoded ?? "")")
                return base64Decoded ?? ""
            }
        }
        return ""
    }
    
    func createPlayer(username: String, email: String){
        let db = Firestore.firestore()
        let player = Player(username: username,
                            name: "NewPlayerName",
                            surname: "NewPlayerSurname",
                            email: email,
                            passCount: 0,
                            point: 0,
                            rank: 1,
                            correctAnswerCount: 0,
                            wrongAnswerCount: 0,
                            friendList: [],
                            incomingFriendRequests: [],
                            outgoingFriendRequests: [])
        do {
            try db.collection("players").document(username).setData(player.asDictionary())
            let defaults = UserDefaults.standard
            //persisting User
            try defaults.set(player.asDictionary(), forKey: "userProfile")
            defaults.set(username, forKey: "username")
        } catch let error {
            print("Error writing player to Firestore: \(error)")
        }
    }
    
    func setIsUsernameExist(username: String){
        let db = Firestore.firestore()
        let docRef = db.collection("players").document(username)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                isUsernameExist = true
            } else {
                isUsernameExist = false
            }
        }
    }
    
    func register(username: String, email: String, password: String){
        setIsUsernameExist(username: username)
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if error != nil {
                print(error!.localizedDescription)
                vm.showError(message: error!.localizedDescription)
            }
            else {
                if !isUsernameExist {
                    createPlayer(username: username, email: email)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(email, forKey: "e-mail")
                    userDefaults.set(true, forKey: "hasSignedInBefore")
                } else {
                    vm.showError(message: "This username is already in use")
                }
            }
        }
    }
    
    var body : some View {
        content
    }
    
    var content : some View {
        Group {
            VStack {
                Spacer()
                    .frame(minHeight: 0, idealHeight: 245.0, maxHeight: 300)
                header
                inputs
                Spacer()
                    .frame(minHeight: 0, idealHeight: 150.0, maxHeight: 150)
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    isUserLoggedIn = true
                } else {
                    isUserLoggedIn = false
                }
            }
        }
    }
    
    var inputs: some View {
        Group {
            HStack {
                Spacer().frame(width:100)
                TextField(
                    "Username",
                    text: $username
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .multilineTextAlignment(.center)
                .focused($isInputActive)
            .textInputAutocapitalization(.never)
                Button("X") {
                    username = ""
                }
                Spacer().frame(width:80)
            }
            Divider()
                .frame(width: 150.0)
            HStack {
                Spacer().frame(width:100)
                TextField(
                    "Email",
                    text: $email
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .multilineTextAlignment(.center)
            .focused($isInputActive)
                Button("X") {
                    email = ""
                }
                Spacer().frame(width:80)
            }
            Divider()
                .frame(width: 150.0)
            HStack {
                Spacer().frame(width:100)
                SecureField(
                    "Password",
                    text: $password)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .multilineTextAlignment(.center)
            .focused($isInputActive)
                Button("X") {
                    password = ""
                }
                Spacer().frame(width:80)
            }
            Divider()
                .frame(width: 150.0)
            HStack {
                Spacer().frame(width:100)
                SecureField(
                    "Re-Enter Your Password",
                    text: $rePassword).textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                    .focused($isInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isInputActive = false
                            }
                        }
                }
                Button("X") {
                    rePassword = ""
                }
                Spacer().frame(width:80)
            }
            Divider()
                .frame(width: 150.0)
            Spacer()
                .frame(minHeight: 0, idealHeight:  16.0, maxHeight: 16)
            Button("Sign Up") {
                if rePassword == password {
                    DispatchQueue.main.async {
                        register(username: username, email: email, password: password)
                    }
                }
                else {
                    isPresented = true
                }
            }.popover(isPresented: $isPresented) {
                Text("Passwords Did not Match!")
                    .font(.headline)
                    .padding()
            }
        }.alert(isPresented: $vm.showError, content: {
            Alert(title: Text(vm.errorMessage))
        })
    }
    
    var header: some View {
        Group {
            Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 58.0, height: 50.0)
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Sign Up").font(.system(size: 40, weight: .bold, design: .rounded)).foregroundColor(.blue)
            Spacer()
                .frame(minHeight: 0, idealHeight:  16.0, maxHeight: 16)
        }
    }
    
}

