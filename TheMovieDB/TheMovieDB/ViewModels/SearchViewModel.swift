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
    
    public func searchMovie(query: String, completion: @escaping () -> Void) {
        currentPage += 1
        let urlString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        SearchNetworkManager.shared.getSearchRequest(page: currentPage, searchQuery: urlString, mediaType: MediaType.movie.rawValue) { [weak self] searched in
            guard let movies = searched.results else { return }
            self?.searchedMedia.append(contentsOf: movies)
            completion()
        }
    }
    
    public func searchTV(query: String, completion: @escaping () -> Void) {
        currentPage += 1
        let urlString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        SearchNetworkManager.shared.getSearchRequest(page: currentPage, searchQuery: urlString, mediaType: MediaType.tvShow.rawValue) { [weak self] searched in
            guard let tvs = searched.results else { return }
            self?.searchedMedia.append(contentsOf: tvs)
            completion()
        }
    }
}
