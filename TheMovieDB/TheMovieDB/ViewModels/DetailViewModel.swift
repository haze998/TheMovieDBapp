//
//  DetailViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 14.02.2023.
//

import Foundation

class DetailViewModel {
    
    weak var delegate: ViewModelProtocol?
    private(set) var currentMovie: MediaResponse.Media?
    private(set) var currentTVShow: MediaResponse.Media?
    private(set) var videosPath: [String] = []
    init(delegate: ViewModelProtocol) {
        self.delegate = delegate
    }
    // MARK: - Media Details request
    func getMovieDetails(movieID: Int) {
        delegate?.showLoading()
        DetailNetworkManager.shared.getMovieDetails(movieId: movieID) { movie in
            DispatchQueue.main.async {
                self.currentMovie = movie
                self.delegate?.hideLoading()
                self.delegate?.updateView()
            }
        }
    }
    func getTVShowDetails(tvShowId: Int) {
        delegate?.showLoading()
        DetailNetworkManager.shared.getTVShowDetails(tvShowId: tvShowId) { tvShow in
            DispatchQueue.main.async {
                self.currentTVShow = tvShow
                self.delegate?.hideLoading()
                self.delegate?.updateView()
            }
        }
    }
    // MARK: - Youtube configure
    func getVideosMovies(movieID: Int) {
        delegate?.showLoading()
        DetailNetworkManager.shared.getVideos(mediaID: movieID, mediaType: MediaType.movie.rawValue) { [weak self] videos in
            DispatchQueue.main.async {
                self?.delegate?.hideLoading()
                let sorted = videos.filter { video in
                    return video.type == "Trailer"
                }
                for video in sorted {
                    self?.videosPath.append(video.key)
                }
                self?.delegate?.reload()
            }
        }
    }
    func getVideosTV(tvShowID: Int) {
        delegate?.showLoading()
        DetailNetworkManager.shared.getVideos(mediaID: tvShowID, mediaType: MediaType.tvShow.rawValue) { [weak self] videos in
            DispatchQueue.main.async {
                self?.delegate?.hideLoading()
                let sorted = videos.filter { video in
                    return video.type == "Trailer"
                }
                for video in sorted {
                    self?.videosPath.append(video.key)
                }
                self?.delegate?.reload()
            }
        }
    }
}
