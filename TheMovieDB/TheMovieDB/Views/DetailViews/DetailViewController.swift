//
//  DetailViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 10.02.2023.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class DetailViewController: UIViewController {
    
    @IBOutlet var bgDetailView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var playerView: YTPlayerView!
    
    private lazy var detailViewModel = DetailViewModel(delegate: self)
    // Default media values
    var movieId = 0
    var tvShowId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }
    
    private func setupUI() {
        let colorTop = UIColor(red: 0.33, green: 0.04, blue: 0.63, alpha: 1.00).cgColor
        let colorBot = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bgDetailView.bounds
        gradientLayer.colors = [colorTop, colorBot]
        self.bgDetailView.layer.insertSublayer(gradientLayer, at: 0)
    }
    // MARK: - Loading Data
    private func loadData() {
        if movieId != 0 {
            detailViewModel.getVideosMovies(movieID: movieId)
            detailViewModel.getMovieDetails(movieID: movieId)
        } else {
            detailViewModel.getVideosTV(tvShowID: tvShowId)
            detailViewModel.getTVShowDetails(tvShowId: tvShowId)
        }
    }
    
    private func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date)
        }
        return nil
    }

}

// MARK: - ViewModelProtocol
extension DetailViewController: ViewModelProtocol {
    func reload() {
        //self.videoCollectionView.reloadData()
    }
    func showLoading() {
//        loaderView.isHidden = false
//        loaderView.startAnimating()
//        view.bringSubviewToFront(loaderView)
    }
    func hideLoading() {
//        loaderView.isHidden = true
//        loaderView.stopAnimating()
    }
    func updateView() {
        if movieId != 0 {
            guard let movie = detailViewModel.currentMovie else { return }
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            self.navigationItem.title = movie.title ?? ""
            self.posterImageView.sd_setImage(with: URL(string: (MediaType.getImage.rawValue + (movie.posterPath ?? ""))), completed: nil)
            posterImageView.layer.cornerRadius = 25
            let attributedDate = formattedDateFromString(dateString: movie.releaseDate ?? "", withFormat: "MMM dd, yyyy")
            titleLabel.text = (movie.title ?? movie.originalTitle ?? "")  + " " + ("(\(attributedDate ?? ""))")
            textView.text = movie.overview
//
//            date.text = formattedText
//            voteAverage.text = "\(round(movie.voteAverage ?? 0.0))"
//            overview.text = movie.overview
//            genresName.removeAll()
//            guard let genresResponse = movie.genres else { return }
//            var genresList = ""
//            for genre in genresResponse {
//                genresList += (genre.name ?? "") + "\n"
//            }
//            genres.text = genresList
//            for int in CheckInWatchList.shared.movieList where movie.id == int {
//                isFavourite = true
//            }
        } else {
            guard let tvShow = detailViewModel.currentTVShow else { return }
            self.navigationItem.title = tvShow.name
            self.posterImageView.sd_setImage(with: URL(string: (MediaType.getImage.rawValue + (tvShow.posterPath ?? ""))), completed: nil)
            posterImageView.layer.cornerRadius = 25
            let attributedDate = formattedDateFromString(dateString: tvShow.firstAirDate ?? "", withFormat: "MMM dd, yyyy")
            titleLabel.text = (tvShow.name ?? tvShow.originalTitle ?? "")  + " " + ("(\(attributedDate ?? ""))")
            textView.text = tvShow.overview
            
//            let formattedText = formattedDateFromString(dateString: tvShow.firstAirDate ?? "",
//                                                        withFormat: "MMM dd, yyyy")
//            date.text = formattedText
//            voteAverage.text = "\(round(tvShow.voteAverage ?? 0.0))"
//            overview.text = tvShow.overview
//            genresName.removeAll()
//            guard let genresResponse = tvShow.genres else { return }
//            var genresList = ""
//            for genre in genresResponse {
//                genresList += (genre.name ?? "") + "\n"
//            }
//            genres.text = genresList
//            for int in CheckInWatchList.shared.tvShowList where tvShow.id == int {
//                isFavourite = true
//            }
        }
//        if isFavourite == true {
//            watchListButton.isSelected = true
//        }
    }
}


