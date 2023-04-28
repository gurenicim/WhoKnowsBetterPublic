//
//  SwiftUIView.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 3.03.2023.
//

import SwiftUI
import Firebase

struct SignInPage: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState var isInputActive: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isUserLoggedIn: Bool
    @State private var welcomeText: String = ""
    @StateObject var vm = ViewModel()
    
    func persistUser() {
        let db = Firestore.firestore()
        db.collection("players").whereField("email", isEqualTo: email)
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
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if error != nil {
                print(error!.localizedDescription)
                vm.showError(message: error!.localizedDescription)
            } else {
                let userDefaults = UserDefaults.standard
                userDefaults.set(email, forKey: "e-mail")
                userDefaults.set(true, forKey: "hasSignedInBefore")
            }
        }
    }
    
    var body: some View {
        content
    }
    
    var content: some View {
        Group{
            VStack(spacing: 16) {
                Group {
                    Spacer()
                        .frame(minHeight: 100, idealHeight: 280)
                    Image(systemName: "person.crop.circle").resizable().frame(width: 50.0, height: 50.0)
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Sign In").font(.system(size: 40,weight: .bold, design: .rounded)).foregroundColor(.blue)
                }
                VStack {
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
                            text: $password
                        )
                        .textInputAutocapitalization(.never)
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
                            password = ""
                        }
                        Spacer().frame(width:80)
                    }
                    Divider()
                        .frame(width: 150.0)
                    Spacer()
                        .frame(width: 0.0, height: 16.0)
                    Button("Sign In") {
                        DispatchQueue.main.async {
                            signIn(email: email, password: password)
                            persistUser()
                        }
                    }
                    Spacer()
                        .frame(height: 140.0)
                }
            }
            .padding()
        }.ignoresSafeArea().onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    isUserLoggedIn = true
                } else {
                    isUserLoggedIn = false
                }
            }
        }.alert(isPresented: $vm.showError, content: {
            Alert(title: Text(vm.errorMessage))
        })
    }
}
