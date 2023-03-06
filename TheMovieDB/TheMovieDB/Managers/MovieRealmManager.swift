//
//  MovieRealmManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 04.03.2023.
//

import Foundation
import RealmSwift

class MovieRealmManager {
    
    let realm = try? Realm()
    
    static let shared = MovieRealmManager()
    
    private init() { }
    
    func saveMovie(type: MediaType, movie: MediaResponse.Media? = nil, tvShow: MediaResponse.Media? = nil) {
        switch type {
            
        case .movie:
            let movieRealm = MovieRealm()
            
            movieRealm.id = movie?.id  ?? 0
            movieRealm.title = movie?.title
            movieRealm.name = movie?.name
            movieRealm.overview = movie?.overview ?? ""
            movieRealm.posterPath = movie?.posterPath
            movieRealm.backdropPath = movie?.backdropPath
            movieRealm.voteAverage = movie?.voteAverage ?? 0
            
            try? realm?.write {
                realm?.add(movieRealm, update: .all)
            }
        case .tvShow:
            let tvShowRealm = MovieRealm()

            tvShowRealm.id = tvShow?.id ?? 0
            tvShowRealm.title = tvShow?.title
            tvShowRealm.name = tvShow?.name
            tvShowRealm.backdropPath = tvShow?.backdropPath
            tvShowRealm.overview = tvShow?.overview ?? ""
            tvShowRealm.posterPath = tvShow?.posterPath
            tvShowRealm.voteAverage = tvShow?.voteAverage ?? 0

               try? realm?.write {
                   realm?.add(tvShowRealm, update: .all)
               }
        case .getImage:
            break
        }
    }
    
    func getMedia() -> [MovieRealm] {
        var array: [MovieRealm] = []
        guard let media = realm?.objects(MovieRealm.self) else { return [MovieRealm]()}
        array = Array(media)
        return array
        
    }
    
    func removeMedia(media: MovieRealm) {
        try? realm?.write({
            realm?.delete(media)
        })
    }
    
    
//    private func convertToMoviesList(moviesRealm: [MovieRealm]) -> [MediaResponse.Media] {
//
//        var movies = [MediaResponse.Media]()
//           for movieRealm in moviesRealm {
//               let movie = try! MediaResponse.Media(from: movieRealm as! Decoder)
//               movies.append(movie)
//           }
//           return movies
//       }
//
//    func getAllMovies(completion: ([MediaResponse.Media]) -> Void) {
//
//        var moviesRealm = [MovieRealm]()
//
//        guard let moviesResult = realm?.objects(MovieRealm.self) else { return }
//        for movie in moviesResult {
//            moviesRealm.append(movie)
//        }
//        completion(convertToMoviesList(moviesRealm: moviesRealm))
//    }
    
    // MARK: - Reset Realm movie storage
//    func resetMovieCache() {
//        let realm = try? Realm()
//        try? realm?.write({
//            realm?.delete(MovieRealm())
//        })
//    }
}

