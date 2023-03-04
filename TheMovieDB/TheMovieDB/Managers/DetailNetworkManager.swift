//
//  DetailNetworkManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 14.02.2023.
//

import Foundation

class DetailNetworkManager {
    static let shared = DetailNetworkManager()
    private init() {}
    
    func getVideos(mediaID: Int, mediaType: String, completion: @escaping (([VideoResponse.Video]) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)\(mediaType)/\(mediaID)/videos?api_key=\(Constants.apiKey)&language=en-US") else {
            fatalError("Invalid URL")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(VideoResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - single movie details
    func getMovieDetails(movieId: Int, completion: @escaping ((MediaResponse.Media) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)movie/\(movieId)?api_key=\(Constants.apiKey)&language=en-US") else {
            fatalError("Invalid URL")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MediaResponse.Media.self, from: data)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    func getTVShowDetails(tvShowId: Int, completion: @escaping ((MediaResponse.Media) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)tv/\(tvShowId)?api_key=\(Constants.apiKey)&language=en-US") else {
            fatalError("Invalid URL")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MediaResponse.Media.self, from: data)
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
