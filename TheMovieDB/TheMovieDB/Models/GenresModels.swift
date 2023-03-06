//
//  GenresModels.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 31.01.2023.
//

import Foundation

// MARK: - Genres
struct GenresResponse: Decodable {
    let genres: [Genre]?
}

// MARK: - Genre
extension GenresResponse {
    struct Genre: Decodable {
        let id: Int?
        let name: String?
    }
}

// MARK: - MoviesByGenre
struct MediaResponse: Decodable, Hashable {
    let page: Int?
    let results: [Media]?
    let totalPages, totalResults: Int?
}

// MARK: - Result
extension MediaResponse {
    struct Media: Decodable, Hashable {
        let adult: Bool?
        let backdropPath: String?
        let budget: Int?
        let firstAirDate: String?
        let genres: [Genre]?
        let homepage: String?
        let id: Int?
        let imdbId: String?
        let originalTitle, overview: String?
        let popularity: Double?
        let posterPath: String?
        let releaseDate: String?
        let revenue, runtime: Int?
        let status, tagline, title, name: String?
        let voteAverage: Double?
        let voteCount: Int?
    }
}

extension MediaResponse.Media {
    struct Genre: Decodable, Hashable {
        let id: Int?
        let name: String?
    }
}
