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
    
    // MARK: - Reset Realm TV show storage
    func resetTVShowCache() {
        let realm = try? Realm()
        try? realm?.write({
            realm?.delete(TvShowRealm())
        })
    }
   }

