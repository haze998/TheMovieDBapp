//
//  GenresViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 02.02.2023.
//

import Foundation

class GenresViewModel {
    // - MARK: Sorted movies by genre
    var sortedMovies: [String: [MediaResponse.Media]] = [:]
    
    // - MARK: Sorted TVs by genre
    var sortedTVs: [String: [MediaResponse.Media]] = [:]
    
    var allMovies: [MediaResponse.Media] = []
    
//    // MARK: - Get movies by genre
    func getSortedMovies(completion: @escaping () -> Void) {
        GenresNetworkManager.shared.sortedMediaList(mediaType: MediaType.movie.rawValue) { [weak self] movie in
            guard let self = self else { return }
            self.sortedMovies = movie
            completion()
        }
    }
//    // MARK: - Get TVs by genre
    func getSortedTVs(completion: @escaping () -> Void) {
        GenresNetworkManager.shared.sortedMediaList(mediaType: MediaType.tvShow.rawValue) { [weak self]
            tv in
            guard let self = self else { return }
            self.sortedTVs = tv
            completion()
        }
    }
}
