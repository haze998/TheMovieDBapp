//
//  TVShowRealmManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 04.03.2023.
//

import Foundation
import RealmSwift

struct TVShowRealmManager {

    let realm = try? Realm()

       static let shared = TVShowRealmManager()

       private init() { }

    func saveTvShow(tvShow: MediaResponse.Media, completion: @escaping () -> Void) {

           let tvShowRealm = TvShowRealm()

        tvShowRealm.id = tvShow.id ?? 0
        tvShowRealm.title = tvShow.title
        tvShowRealm.name = tvShow.name
        tvShowRealm.backdropPath = tvShow.backdropPath
        tvShowRealm.overview = tvShow.overview ?? ""
        tvShowRealm.posterPath = tvShow.posterPath
        tvShowRealm.voteAverage = tvShow.voteAverage ?? 0

           try? realm?.write {
               realm?.add(tvShowRealm)
           }
           completion()
       }
    
//    private func convertToMoviesList(tvShowsRealm: [TvShowRealm]) -> [MediaResponse.Media] {
//
//        var tvShows = [MediaResponse.Media]()
//        for tvShowRealm in tvShowsRealm {
//            let tvShow = try! MediaResponse.Media(from: tvShowRealm as! Decoder)
//            tvShows.append(tvShow)
//        }
//        return tvShows
//    }
//
//    func getAllMovies(completion: ([MediaResponse.Media]) -> Void) {
//
//           var tvShowRealm = [TvShowRealm]()
//           guard let tvShowResults = realm?.objects(TvShowRealm.self) else { return }
//           for tvShow in tvShowResults {
//            tvShowRealm.append(tvShow)
//           }
//
//           completion(convertToMoviesList(tvShowsRealm: tvShowRealm))
//       }
    
    // MARK: - Reset Realm TV show storage
    func resetTVShowCache() {
        let realm = try? Realm()
        try? realm?.write({
            realm?.delete(TvShowRealm())
        })
    }
   }

