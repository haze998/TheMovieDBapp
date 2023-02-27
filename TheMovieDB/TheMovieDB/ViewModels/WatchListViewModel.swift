//
//  WatchListViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 26.02.2023.
//

import Foundation

final class WatchListViewModel {
    var moviesList: [MediaResponse.Media] = []
    var tvShowsList: [MediaResponse.Media] = []
    
    func getWatchList(completion: @escaping () -> Void) {
//        if StorageSecure.keychain["guestID"] != nil {
//            moviesList.removeAll()
//            tvShowsList.removeAll()
//        }
        if let accountID = StorageSecure.keychain["accountID"],
           let sessionID = StorageSecure.keychain["sessionID"] {
            WatchListNetworkManager.shared.getMovieWatchList(accountID: accountID,
                                             sessionID: sessionID,
                                             mediaType: MediaType.movie.rawValue) { movies in
                DispatchQueue.main.async {
                    self.moviesList = movies
                    completion()
                }
            }
            WatchListNetworkManager.shared.getTVShowWatchList(accountID: accountID,
                                             sessionID: sessionID,
                                             mediaType: MediaType.tvShow.rawValue) { tvShow in
                DispatchQueue.main.async {
                    self.tvShowsList = tvShow
                    completion()
                }
            }
        }
    }
}

