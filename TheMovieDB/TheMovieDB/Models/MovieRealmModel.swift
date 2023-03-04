//
//  MovieRealmModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 04.03.2023.
//

import Foundation
import RealmSwift

class MovieRealm: Object {
    @Persisted var backdropPath: String?
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String?
    @Persisted var overview: String
    @Persisted var posterPath: String?
    @Persisted var title: String?
    @Persisted var voteAverage: Double
}


