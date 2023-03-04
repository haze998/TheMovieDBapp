//
//  CastNetworkManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 18.02.2023.
//

import Foundation

class CastNetworkManager {
    static let shared = CastNetworkManager()
    private init() {}
    
    func requestMovieActors(movieId: Int, mediaType: String, completion: @escaping (([Cast]?) -> Void)) {
        guard let apiURL = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US") else { fatalError("Invalid URL") }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(CastAndCrewResult.self, from: data)
                DispatchQueue.main.async {
                    let actors = response.cast ?? []
                    completion(actors)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func requestTVShowActors(tvShowId: Int, completion: @escaping (([Cast]?) -> Void)) {
        guard let apiURL = URL(string: "https://api.themoviedb.org/3/tv//\(tvShowId)/aggregate_credits?api_key=32ea20e318793cf10469df41ffe5990d&language=en-US") else { fatalError("Invalid URL") }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(CastAndCrewResult.self, from: data)
                DispatchQueue.main.async {
                    let actors = response.cast ?? []
                    completion(actors)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
//    func requestMovieActors(movieId: Movie?, completion: @escaping(([Cast]?) -> ())) {
//        if let movieIdForUrl = movieId?.id{
//            let url = Constants.network.moviePath + "/\(movieIdForUrl)" + Constants.network.movieActorsPath
//
//            AF.request(url).responseJSON { responce in
//                let decoder = JSONDecoder()
//                if let data = try? decoder.decode(CastAndCrewResult.self, from: responce.data!) {
//                    let actors = data.cast ?? []
//                    completion(actors)
//                }
//            }
//        }
//    }
//
//    func requestTVShowActors(tvShowId: TvShow?, completion: @escaping(([Cast]?) -> ())) {
//        if let tvShowIdForUrl = tvShowId?.id{
//            let url = Constants.network.tvShowPath + "/\(tvShowIdForUrl)" + Constants.network.tvShowActorsPath
//
//            AF.request(url).responseJSON { responce in
//                let decoder = JSONDecoder()
//                if let data = try? decoder.decode(CastAndCrewResult.self, from: responce.data!) {
//                    let actors = data.cast ?? []
//                    completion(actors)
//                }
//            }
//        }
//    }
}
