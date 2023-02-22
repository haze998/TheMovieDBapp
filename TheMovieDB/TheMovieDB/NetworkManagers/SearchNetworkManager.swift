//
//  SearchNetworkManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 19.02.2023.
//

import Foundation

class SearchNetworkManager {
    static let shared = SearchNetworkManager()
    // MARK: - SearchViewController requests
    func getSearchRequest(page: Int, searchQuery: String, completion: @escaping ((MediaResponse) -> Void)) {
        guard let apiURL = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.apiKey)&page=\(page)&query=\(searchQuery)") else { fatalError("Invalid URL") }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MediaResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}
