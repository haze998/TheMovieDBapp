//
//  GenresNetworkManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 31.01.2023.
//

import Foundation

class GenresNetworkManager {
    
    static let shared = GenresNetworkManager()
    
    // MARK: - Get list of movies genres
    // MARK: - genres
    func getGenres(mediaType: String, completion: @escaping (([GenresResponse.Genre]) -> Void)) {
        guard let apiURL = URL(string: "\(Constants.mainURL)genre/\(mediaType)/list?api_key=\(Constants.apiKey)&language=en-US") else {
            fatalError("Invalid URL")
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(GenresResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.genres!)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }

    func sortedMediaList(mediaType: String, completion: @escaping (([String: [MediaResponse.Media]]) -> Void)) {
        getGenres(mediaType: mediaType, completion: { response in
            var dict: [String: [MediaResponse.Media]] = [:]
            for genre in response {
                guard let genreId = genre.id else { return }
                guard let apiURL = URL(string: "https://api.themoviedb.org/3/discover/\(mediaType)?api_key=\(Constants.apiKey)&language=en-US&sort_by=popularity.desc&with_genres=\(genreId)") else {
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
                            dict[genre.name!] = response.results
                            completion(dict)
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
                task.resume()
            }
        }
                        
    )}
}
                        

