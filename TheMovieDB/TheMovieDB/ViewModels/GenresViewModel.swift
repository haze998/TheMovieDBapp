//
//  GenresViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 02.02.2023.
//

import Foundation

//enum SectionType {
//    case movies([MediaResponse.Media])
//    case tvShows([MediaResponse.Media])
//}

class GenresViewModel {
    
    //var section = [SectionType]()
    
    // - MARK: List of movies genre
    //var movieGenre: [GenresResponse.Genre] = []
    
    // - MARK: List of TVs genre
   // var tvsGenre: [GenresResponse.Genre] = []

    // - MARK: Sorted movies by genre
    var sortedMovies: [String: [MediaResponse.Media]] = [:]
    
    // - MARK: Sorted TVs by genre
    var sortedTVs: [String: [MediaResponse.Media]] = [:]
    
    var allMovies: [MediaResponse.Media] = []
    
    
     // MARK: - Get movies genres list
//    func updateMoviesGenres(completion: @escaping () -> Void) {
//        GenresNetworkManager.shared.getMoviesGenres { [weak self] genreMovie in
//            guard let self = self else { return }
//            self.movieGenre.append(contentsOf: genreMovie)
//            completion()
//        }
//    }
//    // MARK: - Get TVs genres list
//    func updateTvsGenres(completion: @escaping () -> Void) {
//        GenresNetworkManager.shared.getTVGenres { [weak self] genreTVs in
//            guard let self = self else { return }
//            self.tvsGenre.append(contentsOf: genreTVs)
//            completion()
//        }
//    }
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
        GenresNetworkManager.shared.sortedMediaListTV(mediaType: MediaType.tvShow.rawValue) { [weak self]
            tv in
            guard let self = self else { return }
            self.sortedTVs = tv
            completion()
        }
    }
}
