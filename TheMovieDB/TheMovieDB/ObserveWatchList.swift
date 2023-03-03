//
//  ObserveWatchList.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 27.02.2023.
//

import Foundation

final class ObserveWatchList {
    static let shared = ObserveWatchList()
    
    var movieList: [Int] = []
    var tvShowList: [Int] = []
    
    func getMoviesID(completion: @escaping ([Int]) -> Void) {
        //var idMovieNumbers: [Int] = []
        if let accountID = StorageSecure.keychain["accountID"],
           let sessionID = StorageSecure.keychain["sessionID"] {
            WatchListNetworkManager.shared.getMovieWatchList(accountID: accountID,
                                                             sessionID: sessionID,
                                                             mediaType: MediaType.movie.rawValue) { movies in
                //                DispatchQueue.main.async {
                //                    for movie in movies {
                //                        if let id = movie.id {
                //                            idMovieNumbers.append(id)
                //                        }
                //                    }
                //                    self.movieList.append(contentsOf: idMovieNumbers)
                completion(movies.map { $0.id ?? 0 })
                
            }
            
        }
        
    }
    func getTVShowsID(completion: () -> Void) {
        var idTVNumbers: [Int] = []
        if let accountID = StorageSecure.keychain["accountID"],
           let sessionID = StorageSecure.keychain["sessionID"] {
            WatchListNetworkManager.shared.getTVShowWatchList(accountID: accountID,
                                                              sessionID: sessionID,
                                                              mediaType: MediaType.tvShow.rawValue) { movies in
                DispatchQueue.main.async {
                    for movie in movies {
                        if let id = movie.id {
                            idTVNumbers.append(id)
                        }
                    }
                    self.tvShowList.append(contentsOf: idTVNumbers)
                }
            }
        }
    }
}
