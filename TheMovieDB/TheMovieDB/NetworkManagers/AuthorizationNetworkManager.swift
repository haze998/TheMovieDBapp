//
//  AuthorizationNetworkManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.01.2023.
//

import Foundation

class AuthNetworkManager {
    static let shared = AuthNetworkManager()
    
    private init() {}
    
    // MARK: - Get token
    func getRequestToken(completion: @escaping ((TokenResponse) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)\(Constants.auth)token/new?api_key=\(Constants.apiKey)") else {
            fatalError("Invalid URL")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TokenResponse.self, from: data)
                DispatchQueue.main.async {
                    print(response)
                    completion(response)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }

    // MARK: - Validate request token
    func getValidateRequestToken(login: String, password: String, requestToken: String, completion: @escaping ((TokenResponse) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)authentication/token/validate_with_login?api_key=\(Constants.apiKey)") else { fatalError("Invalid URL") }
        let usersData: [String: Any] = [
            "username": login,
            "password": password,
            "request_token": requestToken
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: usersData)
        var request = URLRequest(url: apiURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TokenResponse.self, from: data)
                DispatchQueue.main.async {
                    print(response)
                    completion(response)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - Create session ID
    func createSessionId(requestToken: String, completion: @escaping ((SessionIdResponse)) -> Void) {
        guard let apiURL = URL(string: "\(Constants.mainURL)authentication/session/new?api_key=\(Constants.apiKey)") else { fatalError("Invalid URL") }
        let usersData: [String: Any] = [
            "request_token": requestToken
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: usersData)
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SessionIdResponse.self, from: data)
                DispatchQueue.main.async {
                    print(response)
                    completion(response)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    // - MARK: create guest session
    func getGuestSessionID(completion: @escaping ((GuestSessionID) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)authentication/guest_session/new?api_key=\(Constants.apiKey)") else { fatalError("Invalid URL") }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GuestSessionID.self, from: data)
                DispatchQueue.main.async {
                    print(response)
                    completion(response)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - Get account
    func getAccount(sessionID: String, completion: @escaping ((Account) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)account?api_key=\(Constants.apiKey)&session_id=\(sessionID)") else {
            fatalError("Invalid URL")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(Account.self, from: data)
                DispatchQueue.main.async {
                    print(response)
                    completion(response)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - Delete session
    func deleteSession(sessionID: String) {
        guard let apiURL = URL(string: "\(Constants.mainURL)authentication/session?api_key=\(Constants.apiKey)") else {
            fatalError("Invalid URL")
        }
        let params: [String: Any] = [
            "session_id": sessionID
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: apiURL)
        request.httpMethod = "DELETE"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TokenResponse.self, from: data)
                DispatchQueue.main.async {
                    do {
                        try StorageSecure.keychain.removeAll()
                        print(response)
                    } catch {
                        print("Error")
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }


}

