//
//  Constants.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 08.02.2023.
//

import Foundation

enum MediaType: String {
    case movie = "movie"
    case tvShow = "tv"
    case getImage = "https://image.tmdb.org/t/p/original"
    //case movies = "movies"
}

enum Media {
    case movie(movie: MediaResponse.Media)
    case tvShow(tvShow: MediaResponse.Media)
}

struct Constants {
    static let apiKey = "aef19f83a7261debd6b9b8edfd7919ce"
    static let mainURL = "https://api.themoviedb.org/3/"
    static let auth = "authentication/"
}

