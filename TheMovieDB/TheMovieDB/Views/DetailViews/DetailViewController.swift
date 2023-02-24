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
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet var bgDetailView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            let nib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
//            collectionView.register(ActorHeaderSection.self,
//                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                                    withReuseIdentifier: ActorHeaderSection.reuseId)
            collectionView.collectionViewLayout = createLayoutBuilder()
        }
    }
    private var viewModel = DetailViewModel()
    // Default media values
    var movieId = 0
    var tvShowId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
       // loadActors()
    }
    
    private func setupUI() {
        let colorTop = UIColor(red: 0.33, green: 0.04, blue: 0.63, alpha: 1.00).cgColor
        let colorBot = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bgDetailView.bounds
        gradientLayer.colors = [colorTop, colorBot]
        self.bgDetailView.layer.insertSublayer(gradientLayer, at: 0)
        collectionView.backgroundColor = .clear
    }
    // MARK: - Loading Data
    private func loadData() {
        viewModel.getDetails(movieId: movieId, tvShowId: tvShowId) {
            self.updateView()
            self.loadActors()
        }
        viewModel.getVideos(movieId: movieId, tvShowId: tvShowId) {
            self.loadTrailer()
        }
    }
    // MARK: - Loading Actors
    private func loadActors() {
        viewModel.getActors(movieId: movieId, tvShowId: tvShowId) {
            self.collectionView.reloadData()
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
    
    private func loadTrailer() {
        let playvarsDic = ["controls": 1, "playsinline": 0, "modestbranding": 1]
        playerView.load(withVideoId: viewModel.videosPath.first ?? "", playerVars: playvarsDic)
    }
        
     func updateView() {
            if movieId != 0 {
                guard let movie = viewModel.currentMovie else { return }
                let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                navigationController?.navigationBar.titleTextAttributes = textAttributes
                self.navigationItem.title = movie.title ?? ""
                self.posterImageView.sd_setImage(with: URL(string: (MediaType.getImage.rawValue + (movie.posterPath ?? ""))), completed: nil)
                posterImageView.layer.cornerRadius = 25
                let attributedDate = formattedDateFromString(dateString: movie.releaseDate ?? "", withFormat: "MMM dd, yyyy")
                titleLabel.text = (movie.title ?? movie.originalTitle ?? "")
                textView.text = movie.overview
                runtimeLabel.text = "\(movie.runtime ?? 0) minutes"
                voteCountLabel.text = "\(movie.voteAverage ?? 0.0) (TMDB)"
                releaseDateLabel.text = attributedDate

                guard let movieGenresFilter = movie.genres else { return }
                var movieGenresCounter = ""
                for genre in movieGenresFilter {
                    movieGenresCounter += (genre.name ?? "") + " "
                }
                genreLabel.text = movieGenresCounter
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
                guard let tvShow = viewModel.currentTVShow else { return }
                self.navigationItem.title = tvShow.name
                self.posterImageView.sd_setImage(with: URL(string: (MediaType.getImage.rawValue + (tvShow.posterPath ?? ""))), completed: nil)
                posterImageView.layer.cornerRadius = 25
                let attributedDate = formattedDateFromString(dateString: tvShow.firstAirDate ?? "", withFormat: "MMM dd, yyyy")
                titleLabel.text = (tvShow.name ?? tvShow.originalTitle ?? "")
                textView.text = tvShow.overview
                runtimeLabel.isHidden = true
                runtimeLabel.text = "\(tvShow.runtime ?? 0)"
                voteCountLabel.text = "\(tvShow.voteAverage ?? 0.0) (TMDB)"
                releaseDateLabel.text = attributedDate

                guard let tvGenresFilter = tvShow.genres else { return }
                var tvGenresCounter = ""
                for genre in tvGenresFilter {
                    tvGenresCounter += (genre.name ?? "") + " "
                }
                genreLabel.text = tvGenresCounter

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
    
    private func createLayout() -> NSCollectionLayoutSection? {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                     leading: 4,
                                                     bottom: 8,
                                                     trailing: 4)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 4,
                                                      bottom: 8,
                                                      trailing: 4)
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                heightDimension: .fractionalHeight(0.05))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
//                                                                 elementKind: UICollectionView.elementKindSectionHeader,
//                                                                 alignment: .topLeading)
        let section = NSCollectionLayoutSection(group: group)
        //section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }
    
    private func createLayoutBuilder() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in return self.createLayout()
        }
    }
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.movieActorsArray.count != 0 {
            return viewModel.movieActorsArray.count
        } else {
            return viewModel.tvShowActorsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        if viewModel.movieActorsArray.count != 0 {
            let currentActor = viewModel.movieActorsArray[indexPath.row]
            cell.configure(actor: currentActor)
            return cell
        } else {
            let currentActor = viewModel.tvShowActorsArray[indexPath.row]
            cell.configure(actor: currentActor)
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ActorHeaderSection.reuseId, for: indexPath) as? ActorHeaderSection else { return UICollectionReusableView() }
//
//            sectionHeader.label.text = "Actors"
//            return sectionHeader
//        }
//        return UICollectionReusableView()
//    }
    
}

extension DetailViewController: UICollectionViewDelegate {}
//
//extension DetailViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemHeight = collectionView.bounds.height
//        let itemWith = collectionView.bounds.width / 6
//        return CGSize(width: itemWith, height: itemHeight)
//    }
//}
