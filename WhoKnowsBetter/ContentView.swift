//
//  ContentView.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 1.03.2023.
//

import SwiftUI
import Firebase

func attrString(text: String) -> AttributedString {
    var result = AttributedString(text)
    result.font = .largeTitle
    result.foregroundColor = .black
    return result 
}

func isSignUpLaunch( userDefaults: UserDefaults) -> Bool {
    var result: Bool = false
    if (!userDefaults.bool(forKey: "hasRunBefore")) {
        print("The app is launching for the first time. Setting UserDefaults...")
        
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
        
        // Update the flag indicator
        userDefaults.set(true, forKey: "hasRunBefore")
        userDefaults.synchronize() // This forces the app to update userDefaults
        
        return true
        
    } else {
        if UserDefaults.standard.bool(forKey: "hasSignedInBefore") {
            print("The app has been launched before with signing.")
            result = false
        } else {
            print("The app has been launched before but no signing.")
            result = true
        }
        return result
    }
}


struct ContentView : View {
    @State private var isSignUpLaunchPage: String = "SingIn"
    @State private var isTabBarVisible: Bool = true
    @State private var isLoggedIn: Bool = false
    var body: some View {
        if !isLoggedIn {
            VStack {
                TabView(selection: $isSignUpLaunchPage) {
                    SignUpPage(isUserLoggedIn: $isLoggedIn).tabItem { Text("Sign Up") }.tag("SignUp")
                    SignInPage(isUserLoggedIn: $isLoggedIn).tabItem { Text("Sign In") }.tag("SignIn")
                }.onAppear {
                    isSignUpLaunchPage = isSignUpLaunch(userDefaults: UserDefaults.standard) ? "SignUp" : "SignIn"
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            isTabBarVisible = false
                        } else {
                            isTabBarVisible = true
                        }
                    }
                }.tabViewStyle(.page(indexDisplayMode: .never))
                if isTabBarVisible {
                    tabBar
                } else {
                    tabBar.hidden()
                }
            }
        } else {
            AppFlowView()
        }
    }
    
    var tabBar: some View {
        HStack(alignment: .lastTextBaseline) {
            CustomTabBarItem(iconName: "person.crop.circle.badge.plus", label: "Sign Up")
                .previewLayout(.fixed(width: 80, height: 80))
                .onTapGesture {
                    isSignUpLaunchPage = "SignUp"
                }
            CustomTabBarItem(iconName: "person.crop.circle", label: "Sign In")
                .previewLayout(.fixed(width: 80, height: 80))
                .onTapGesture {
                    isSignUpLaunchPage = "SignIn"
                }
        }
    }
}
