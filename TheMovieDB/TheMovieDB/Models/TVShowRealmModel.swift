//
//  TVShowRealmModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 04.03.2023.
//

import Foundation
import RealmSwift

class TvShowRealm: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String?
    @Persisted var name: String?
    @Persisted var backdropPath: String?
    @Persisted var overview: String
    @Persisted var posterPath: String?
    @Persisted var voteAverage: Double
}

