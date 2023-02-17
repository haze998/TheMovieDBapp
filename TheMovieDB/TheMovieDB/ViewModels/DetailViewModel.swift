//
//  DetailViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 14.02.2023.
//

import Foundation

class DetailViewModel {
    
    //    weak var delegate: ViewModelProtocol?
    private(set) var currentMovie: MediaResponse.Media?
    private(set) var currentTVShow: MediaResponse.Media?
    private(set) var videosPath: [String] = []
    //    init(delegate: ViewModelProtocol) {
    //        self.delegate = delegate
    //    }
    // MARK: - Media Details request
        
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
    
//
//    func getMovieDetails(movieID: Int, completion: @escaping () -> ()) {
//        //        delegate?.showLoading()
//        DetailNetworkManager.shared.getMovieDetails(movieId: movieID) { movie in
//            //            DispatchQueue.main.async {
//            self.currentMovie = movie
//            //                self.delegate?.hideLoading()
//            //                self.delegate?.updateView()
//            //            }
//            completion()
//        }
//    }
//    func getTVShowDetails(tvShowId: Int) {
//        //        delegate?.showLoading()
//        DetailNetworkManager.shared.getTVShowDetails(tvShowId: tvShowId) { tvShow in
//            DispatchQueue.main.async {
//                self.currentTVShow = tvShow
//                //                self.delegate?.hideLoading()
//                //                self.delegate?.updateView()
//            }
//        }
//    }
    // MARK: - Youtube configure
    func getVideos(movieId: Int?, tvShowId: Int?, completion: @escaping()->()) {

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
//    func getVideosTV(tvShowID: Int) {
//        //        delegate?.showLoading()
//        DetailNetworkManager.shared.getVideos(mediaID: tvShowID, mediaType: MediaType.tvShow.rawValue) { [weak self] videos in
//            DispatchQueue.main.async {
//                //                self?.delegate?.hideLoading()
//                let sorted = videos.filter { video in
//                    return video.type == "Trailer"
//                }
//                for video in sorted {
//                    self?.videosPath.append(video.key)
//                }
//                //                self?.delegate?.reload()
//            }
//        }
//    }
}
