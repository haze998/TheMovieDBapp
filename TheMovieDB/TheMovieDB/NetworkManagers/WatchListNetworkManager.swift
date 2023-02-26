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
    
    func getWatchListMedia(accountID: String, sessionID: String, mediaType: String, completion: @escaping (([MediaResponse.Media]) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)account/\(accountID)/watchlist/\(mediaType)?api_key=\(Constants.apiKey)&language=en-US&session_id=\(sessionID)&page=1") else {
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
    // mediaType for tv???
    func actionWatchList(mediaType: String = "movie", mediaID: String, bool: Bool = true, accountID: String, sessionID: String) {
        guard let apiURL = URL(string: "\(Constants.mainURL)account/\(accountID)/watchlist?api_key=\(Constants.apiKey)&session_id=\(sessionID)") else {
            fatalError("Invalid URL")
        }
        let params: [String: Any] = [
            "media_type": mediaType,
            "media_id": mediaID,
            "watchlist": bool
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
}
