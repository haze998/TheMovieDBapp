//
//  WatchListNetworkManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 26.02.2023.
//

import Foundation

class WatchListNetworkManager {
    static let shared = WatchListNetworkManager()
    private init() {}
    
    func getMovieWatchList(accountID: String, sessionID: String, mediaType: String, completion: @escaping (([MediaResponse.Media]) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)account/\(accountID)/watchlist/movies?api_key=\(Constants.apiKey)&language=en-US&session_id=\(sessionID)&page=1") else {
            fatalError("Invalid URL")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MediaResponse.self, from: data)
                DispatchQueue.main.async {
                    guard let results = response.results else { return }
                    completion(results)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func getTVShowWatchList(accountID: String, sessionID: String, mediaType: String, completion: @escaping (([MediaResponse.Media]) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)account/\(accountID)/watchlist/tv?api_key=\(Constants.apiKey)&language=en-US&session_id=\(sessionID)&page=1") else {
            fatalError("Invalid URL")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MediaResponse.self, from: data)
                DispatchQueue.main.async {
                    guard let results = response.results else { return }
                    completion(results)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    // - MARK: Added selected movie/tv to watch list
    func getWatchList(mediaType: String, mediaID: String, status: Bool, accountID: String, sessionID: String) {
        guard let apiURL = URL(string: "\(Constants.mainURL)account/\(accountID)/watchlist?api_key=\(Constants.apiKey)&session_id=\(sessionID)") else {
            fatalError("Invalid URL")
        }
        let params: [String: Any] = [
            "media_type": mediaType,
            "media_id": mediaID,
            "watchlist": status
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TokenResponse.self, from: data)
                DispatchQueue.main.async {
                    print(response)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    // - MARK: Remove selected movie from watch list list
    func removeWatchList(mediaType: String, mediaID: Int, accountID: String, sessionID: String, completion: @escaping (TokenResponse) -> Void) {
        guard let apiURL = URL(string: "https://api.themoviedb.org/3/account/\(accountID)/watchlist?api_key=\(Constants.apiKey)&session_id=\(sessionID)") else { fatalError("Invalid URL") }
        let params: [String: Any] = [
            "media_type": mediaType,
            "media_id": mediaID,
            "watchlist": false
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TokenResponse.self, from: data)
                //DispatchQueue.main.async {
                    print(response)
               // }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}

