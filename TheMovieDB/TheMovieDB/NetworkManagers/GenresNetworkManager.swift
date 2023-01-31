//
//  GenresNetworkManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 31.01.2023.
//

import Foundation
import Alamofire

class GenresNetworkManager {
    
    static let shared = GenresNetworkManager()
    // MARK: - Get list of movies genres
    func GetMoviesGenres() {
        let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US"
        let request = AF.request(url, method: .get)
        request.responseDecodable(of: Genres.self) { response in
            do {
                let genres = try response.result.get().genres
                print(genres)
            } catch {
                print(error)
            }
        }
    }
    // MARK: - Get list of TV genres
    func GetTVGenres() {
        let url = "https://api.themoviedb.org/3/genre/tv/list?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US"
        let request = AF.request(url, method: .get)
        request.responseDecodable(of: Genres.self) { responce in
            do {
                let tvGenres = try responce.result.get().genres
                print(tvGenres)
            } catch {
                print(error)
            }
        }
    }
    // MARK: - Get movies with genre
    func getMovies() {
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        let request = AF.request(url, method: .get)
        request.responseDecodable(of: MoviesByGenre.self) { response in
            do {
                let movies = try response.result.get().results
                print(movies)
            } catch {
                print(error)
            }
        }
    }
    // MARK: - Get movies with genre
    func getTVs() {
        let url = "https://api.themoviedb.org/3/discover/tv?api_key=aef19f83a7261debd6b9b8edfd7919ce&language=en-US&sort_by=popularity.desc&page=1&timezone=America%2FNew_York&include_null_first_air_dates=false&with_watch_monetization_types=flatrate&with_status=0&with_type=0"
        let request = AF.request(url, method: .get)
        request.responseDecodable(of: MoviesByGenre.self) { response in
            do {
                let tv = try response.result.get().results
                print(tv)
            } catch {
                print(error)
            }
        }
    }
}
