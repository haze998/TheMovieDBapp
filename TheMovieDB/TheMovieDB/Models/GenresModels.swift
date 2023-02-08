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
//struct Genres: Codable {
//    let genres: [Genre]
//}

// MARK: - Genre
extension GenresResponse {
    struct Genre: Decodable {
        let id: Int?
        let name: String?
    }
}
//struct Genre: Codable, Equatable {
//    let id: Int
//    let name: String
//}

// MARK: - MoviesByGenre
struct MediaResponse: Decodable, Hashable {
    let page: Int?
    let results: [Media]?
    let totalPages, totalResults: Int?
}
//struct MoviesByGenre: Codable {
//    let page: Int
//    let results: [Media]
//    let totalPages, totalResults: Int
//
//    enum CodingKeys: String, CodingKey {
//        case page, results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
//}

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
//struct Media: Codable, Equatable, Hashable {
//    var identity: Int { return id }
//
//    typealias Identity = Int
//
//    let backdropPath: String?
//    let id: Int
//    let name: String?
//    let overview: String
//    let posterPath: String?
//    let title: String?
//    let voteAverage: Double
//
//    enum CodingKeys: String, CodingKey {
//        case backdropPath = "backdrop_path"
//        case id
//        case overview
//        case posterPath = "poster_path"
//        case title
//        case voteAverage = "vote_average"
//        case name
//    }
//}
extension MediaResponse.Media {
    struct Genre: Decodable, Hashable {
        let id: Int?
        let name: String?
    }
}
