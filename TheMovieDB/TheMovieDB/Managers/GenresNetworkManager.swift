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

//    func getMoviesGenres(completion: @escaping ([GenresResponse.Genre]) -> ()) {
//        let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US"
//        let request = AF.request(url, method: .get)
//        request.responseDecodable(of: GenresResponse.self) { response in
//            do {
//                let genres = try response.result.get().genres
//                completion(genres!)
//            } catch {
//                print(error)
//            }
//        }
//    }
    //    func getGenres(mediaType: String, completion: @escaping (([GenresResponse.Genre]) -> Void)) {
    //        guard let apiURL = URL(string: "\(Constants.mainURL)genre/\(mediaType)/list?api_key=\(Constants.apiKey)&language=en-US") else {
    //            fatalError("Invalid URL")
    //        }
    //        let session = URLSession(configuration: .default)
    //        let task = session.dataTask(with: apiURL) { data, response, error in
    //            guard let data = data else { return }
    //            do {
    //                let decoder = JSONDecoder()
    //                decoder.keyDecodingStrategy = .convertFromSnakeCase
    //                let response = try decoder.decode(GenresResponse.self, from: data)
    //                DispatchQueue.main.async {
    //                    completion(response.genres!)
    //                }
    //            } catch {
    //                print("Error: \(error)")
    //            }
    //        }
    //        task.resume()
    //    }
    // MARK: - Get list of TV genres
//    func getTVGenres(completion: @escaping ([GenresResponse.Genre]) -> ()) {
//        let url = "https://api.themoviedb.org/3/genre/tv/list?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US"
//        let request = AF.request(url, method: .get)
//        request.responseDecodable(of: GenresResponse.self) { responce in
//            do {
//                let tvGenres = try responce.result.get().genres
//                completion(tvGenres!)
//            } catch {
//                print(error)
//            }
//        }
//    }
    // MARK: - Get sorted movies and tv shows by genre
    //    func getMovies(completion: @escaping ([String: [MediaResponse.Media]]) -> ()) {
    //        getMoviesGenres { response in
    //            var dict: [String: [MediaResponse.Media]] = [:]
    //            for genre in response {
    //                guard let genreId = genre.id else { return }
    //                let url = "https://api.themoviedb.org/3/discover/movie?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
    //                let request = AF.request(url, method: .get)
    //                request.responseDecodable(of: MediaResponse.self) { response in
    //                    do {
    //                        let movies = try response.result.get().results
    //                        dict[genre.name!] = response.result
    //                            completion(dict)
    //
    //                    } catch {
    //                        print(error)
    //                    }
    //                }
    //            }
    //        }
    //    }
    // ---------
    func sortedMediaList(mediaType: String, completion: @escaping (([String: [MediaResponse.Media]]) -> Void)) {
        getGenres(mediaType: mediaType, completion: { response in
            var dict: [String: [MediaResponse.Media]] = [:]
            for genre in response {
                guard let genreId = genre.id else { return }
                guard let apiURL = URL(string: "https://api.themoviedb.org/3/discover/\(mediaType)?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US&sort_by=popularity.desc&with_genres=\(genreId)") else {
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
    
//    func sortedMediaListTV(mediaType: String, completion: @escaping (([String: [MediaResponse.Media]]) -> Void)) {
//        getGenres(mediaType: mediaType, completion: { response in
//            var dict: [String: [MediaResponse.Media]] = [:]
//            for genre in response {
//                guard let genreId = genre.id else { return }
//                guard let apiURL = URL(string: "https://api.themoviedb.org/3/discover/tv?api_key=aef19f83a7261debd6b9b8edfd7919ce&sort_by=popularity.desc&with_genres=\(genreId)") else {
//                    fatalError("Invalid URL")
//                    
//                }
//                let session = URLSession(configuration: .default)
//                let task = session.dataTask(with: apiURL) { data, response, error in
//                    guard let data = data else { return }
//                    do {
//                        let decoder = JSONDecoder()
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//                        let response = try decoder.decode(MediaResponse.self, from: data)
//                        DispatchQueue.main.async {
//                            dict[genre.name!] = response.results
//                            completion(dict)
//                        }
//                    } catch {
//                        print("Error: \(error)")
//                    }
//                }
//                task.resume()
//            }
//        }
//                        
//    )}
}
                        

