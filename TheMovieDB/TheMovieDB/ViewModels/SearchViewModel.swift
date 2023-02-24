//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 19.02.2023.
//

import Foundation

class SearchViewModel {
    
    public var currentPage = 0
    public let totalPages = 5
    var searchedMedia: [MediaResponse.Media] = []
    //public var genres = [Genre]()
    //public var popular  = [Media]()
    
    public func searchMovie(query: String, completion: @escaping()->Void) {
        currentPage += 1
        SearchNetworkManager.shared.getSearchRequest(page: currentPage, searchQuery: query, mediaType: MediaType.movie.rawValue) { [weak self] searched in
            guard let movies = searched.results, !movies.isEmpty else { return }
            self?.searchedMedia.append(contentsOf: movies)
            completion()
        }
    }
    
    public func searchTV(query: String, completion: @escaping()->Void) {
        currentPage += 1
        SearchNetworkManager.shared.getSearchRequest(page: currentPage, searchQuery: query, mediaType: MediaType.tvShow.rawValue) { [weak self] searched in
            guard let tvs = searched.results, !tvs.isEmpty else { return }
            self?.searchedMedia.append(contentsOf: tvs)
            completion()
        }
    }
}
