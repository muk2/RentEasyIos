//
//  LoginView.swift
//  RentEasy
//
//  Created by Mukund Chanchlani on 8/22/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var message = ""
    @Binding var isLoggedIn: Bool
    @Binding var showSignup: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text("🏡 RentEasy").font(.largeTitle).bold()
            Text("Sign in to continue").foregroundColor(.gray)

            TextField("Username or Email", text: $username)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Sign In") {
                handleLogin()
            }
            .buttonStyle(.borderedProminent)

            Button("New here? Create an account") {
                showSignup = true
            }
            .foregroundColor(.blue)
            .padding(.top, 8)

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
        }
        .padding()
    }

    private func handleLogin() {
        let req = LoginReq(username: username, password: password)
        API.post(endpoint: "/login", body: req) { (result: Result<LoginResp, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let resp):
                    UserDefaults.standard.set(resp.access_token, forKey: "access_token")
                    UserDefaults.standard.set(resp.refresh_token, forKey: "refresh_token")
                    message = resp.message
                    isLoggedIn = true
                case .failure:
                    message = "Login failed. Please check your credentials."
                }
            }
        }
    }
}
#Preview {
    LoginView(
        isLoggedIn: .constant(false),
        showSignup: .constant(true)
    )
}
