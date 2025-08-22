//
//  RentEasyApp.swift
//  RentEasy
//
//  Created by Mukund Chanchlani on 8/21/25.
//

import SwiftUI

@main
struct RentEasyApp: App {
    @State private var isLoggedIn = false
    @State private var showSignup = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                DashboardView(isLoggedIn: $isLoggedIn)
            } else {
                if showSignup {
                    SignupView(showSignup: $showSignup, isLoggedIn: $isLoggedIn)
                } else {
                    LoginView(isLoggedIn: $isLoggedIn, showSignup: $showSignup)
                }
            }
        }
    }
}
