//
//  DetailViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 14.02.2023.
//

import Foundation

class DetailViewModel {
    private(set) var currentMovie: MediaResponse.Media?
    private(set) var currentTVShow: MediaResponse.Media?
    private(set) var videosPath: [String] = []
    private(set) var movieActorsArray: [Cast] = []
    private(set)var tvShowActorsArray: [Cast] = []
    
    func getDetails(movieId: Int?, tvShowId: Int?, completion: @escaping () -> ()) {
        if movieId != 0 {
            DetailNetworkManager.shared.getMovieDetails(movieId: movieId ?? 0) { movie in
                self.currentMovie = movie
                completion()
            }
        } else {
            DetailNetworkManager.shared.getTVShowDetails(tvShowId: tvShowId ?? 0) { tvShow in
                DispatchQueue.main.async {
                    self.currentTVShow = tvShow
                    completion()
                }
            }
        }
    }
    // MARK: - Actors configure
    func getActors(movieId: Int?, tvShowId: Int?, completion: @escaping () -> ()) {
        if movieId != 0 {
            CastNetworkManager.shared.requestMovieActors(movieId: movieId ?? 0, mediaType: MediaType.movie.rawValue) { [weak self] movieActor in
                guard let self = self else { return }
                self.movieActorsArray.append(contentsOf: movieActor ?? [])
                //self.movieActorsArray = movieActor ?? []
                completion()
            }
        } else {
            CastNetworkManager.shared.requestTVShowActors(tvShowId: tvShowId ?? 0) { tvShowActor in
                self.tvShowActorsArray = tvShowActor ?? []
                completion()
            }
        }
    }
    
    func goToWatchList(mediaType: String, mediaID: String, status: Bool) {
        if let accountID = StorageSecure.keychain["accountID"],
           let sessionID = StorageSecure.keychain["sessionID"] {
            WatchListNetworkManager.shared.actionWatchList(mediaType: mediaType,
                                           mediaID: mediaID,
                                           status: status,
                                           accountID: accountID,
                                           sessionID: sessionID)
        }
    }
    
    // MARK: - Youtube configure
    func getVideos(movieId: Int?, tvShowId: Int?, completion: @escaping () -> ()) {
        if movieId != 0 {
            DetailNetworkManager.shared.getVideos(mediaID: movieId ?? 0, mediaType: MediaType.movie.rawValue) { [weak self] videos in
                DispatchQueue.main.async {
                    videos.forEach { [weak self] video in
                        if video.type == "Trailer" {
                            guard let self = self else { return }
                            self.videosPath.append(video.key)
                            completion()
                        }
                        
                    }
                }
            }
        } else {
            DetailNetworkManager.shared.getVideos(mediaID: tvShowId ?? 0, mediaType: MediaType.tvShow.rawValue) { [weak self] videos in
                DispatchQueue.main.async {
                    videos.forEach { [weak self] video in
                        if video.type == "Trailer" {
                            guard let self = self else { return }
                            self.videosPath.append(video.key)
                            completion()
                        }
                        
                    }
                }
            }
        }
        
    }
}
