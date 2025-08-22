//
//  SignupView.swift
//  RentEasy
//
//  Created by Mukund Chanchlani on 8/22/25.
//

import SwiftUI

struct SignupView: View {
    @State private var step = 1
    @State private var userId: Int?
    @State private var role = "renter"

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    @State private var renterFullName = ""
    @State private var renterAge = ""
    @State private var landlordName = ""
    @State private var landlordRole = ""

    @Binding var showSignup: Bool
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 16) {
            if step == 1 {
                Text("Create Account").font(.title)
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                Picker("Role", selection: $role) {
                    Text("Renter").tag("renter")
                    Text("Landlord").tag("landlord")
                }.pickerStyle(.segmented)

                HStack {
                    Button("Back to Login") { showSignup = false }
                    Spacer()
                    Button("Continue") { handleUserSubmit() }
                }
            }

            if step == 2 {
                if role == "renter" {
                    TextField("Full Name", text: $renterFullName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Age", text: $renterAge)
                        .textFieldStyle(.roundedBorder)
                } else {
                    TextField("Name or Entity", text: $landlordName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Role", text: $landlordRole)
                        .textFieldStyle(.roundedBorder)
                }

                HStack {
                    Button("Back") { step = 1; userId = nil }
                    Spacer()
                    Button("Create Profile") { handleProfileSubmit() }
                }
            }
        }
        .padding()
    }

    private func handleUserSubmit() {
        let newUser = NewUser(username: username, email: email, password: password, role: role)
        API.post(endpoint: "/users/add", body: newUser) { (result: Result<[String:Int], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let resp):
                    self.userId = resp["id"]
                    self.step = 2
                case .failure:
                    print("Signup failed")
                }
            }
        }
    }

    private func handleProfileSubmit() {
        guard let uid = userId else { return }

        if role == "renter" {
            let profile: [String: Any] = [
                "user_id": uid,
                "full_name": renterFullName,
                "age": Int(renterAge) ?? 0
            ] as [String : Any]
            postProfile(endpoint: "/profile/renter", profile: profile)
        } else {
            let profile: [String: Any] = [
                "user_id": uid,
                "name_or_entity": landlordName,
                "role": landlordRole
            ]
            postProfile(endpoint: "/profile/landlord", profile: profile)
        }
    }

    private func postProfile(endpoint: String, profile: [String: Any]) {
        guard let url = URL(string: API.baseURL + endpoint) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: profile)

        URLSession.shared.dataTask(with: req) { _, res, err in
            DispatchQueue.main.async {
                if err == nil { isLoggedIn = true }
            }
        }.resume()
    }
}

#Preview {
    SignupView(
        showSignup: .constant(true),
        isLoggedIn: .constant(false)
    )
}
