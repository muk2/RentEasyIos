//
//  NetworkHelpers.swift
//  RentEasy
//
//  Created by Mukund Chanchlani on 8/22/25.
//

import Foundation

struct API {
    static let baseURL = "https://ebackend-rs.onrender.com"

    static func post<T: Encodable, U: Decodable>(
        endpoint: String,
        body: T,
        completion: @escaping (Result<U, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: req) { data, res, err in
            if let err = err { completion(.failure(err)); return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct LoginReq: Codable {
    let username: String
    let password: String
}

struct LoginResp: Codable {
    let message: String
    let access_token: String
    let refresh_token: String
    let user: String
}

struct NewUser: Codable {
    let username: String
    let email: String
    let password: String
    let role: String
}
