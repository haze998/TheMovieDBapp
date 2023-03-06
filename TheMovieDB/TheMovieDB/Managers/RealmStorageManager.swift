//
//  RealmStorageManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 05.03.2023.
//

import Foundation
import RealmSwift

//class RealmStorageManager {
//    
//    static let shared = RealmStorageManager()
//    private init() { }
//    
//    func fetchRealmMovieWatchList(accountID: String, sessionID: String, mediaType: String, completion: @escaping (([MediaResponse.Media]) -> Void)) {
//        WatchListNetworkManager.shared.getMovieWatchList(accountID: accountID,
//                                                         sessionID: sessionID,
//                                                         mediaType: mediaType) { movie in
//            MovieRealmManager.shared.saveMovie(movie: movie.first!) {
//
//            }
//            completion(movie)
//        }
//    }
//    
//}
