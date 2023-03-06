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
    var realmList: [MovieRealm] = []
    
    func fetchedWatchList(completion: @escaping () -> Void) {
        if StorageSecure.keychain["guestID"] != nil {
            moviesList.removeAll()
            tvShowsList.removeAll()
        }
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
    
    func removeFetchedWatchList(mediaType: String, mediaId: Int) {
        if let accountID = StorageSecure.keychain["accountID"],
           let sessionID = StorageSecure.keychain["sessionID"] {
            WatchListNetworkManager.shared.removeWatchList(mediaType: mediaType, mediaID: mediaId, accountID: accountID, sessionID: sessionID) { session in
                print(session)
            }
        }
    }
    
    func getRealmMedia() {
        realmList = MovieRealmManager.shared.getMedia()
    }
    
    func removeRealmMedia(media: MovieRealm) {
        MovieRealmManager.shared.removeMedia(media: media)
        realmList.removeAll()
        realmList = MovieRealmManager.shared.getMedia()
    }
    
}
