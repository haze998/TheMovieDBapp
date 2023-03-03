//
//  DetailViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 10.02.2023.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper
import SwiftEntryKit

class DetailViewController: UIViewController {
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var runtimeImageView: UIImageView!
    @IBOutlet var bgDetailView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var addToWatchListButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            let nib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
            collectionView.collectionViewLayout = createLayoutBuilder()
        }
    }
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 350, height: 400), scaleMode: .aspectFill)
    private var viewModel = DetailViewModel()
    // Default media values
    var buttonActive: Bool = false
    var movieId = 0
    var tvShowId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        hideWatchListButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ObserveWatchList.shared.getMoviesID { iDs in
            for id in iDs {
                if id == self.movieId {
                    self.addToWatchListButton.isSelected = true
                        self.addToWatchListButton.setImage(UIImage(named: "bookmark_pressed"), for: .normal)
                        self.addToWatchListButton.layoutIfNeeded()
                    
                    
                }
            }
        }
    }
    
    @IBAction func addToWatchListButtonPressed(_ sender: UIButton) {
        //addToWatchListButton.isSelected = true
        SwiftEntryKit.display(entry: PopUpView(with: setupPopUpMessage()), using: setupAttributes())
        
        if movieId != 0 {
            viewModel.goToWatchList(mediaType: MediaType.movie.rawValue, mediaID: String(movieId), status: true)
            addToWatchListButton.setImage(UIImage(named: "bookmark_pressed"), for: .normal)
        } else {
            viewModel.goToWatchList(mediaType: MediaType.tvShow.rawValue, mediaID: String(tvShowId), status: true)
            addToWatchListButton.setImage(UIImage(named: "bookmark_pressed"), for: .normal)
        }
    }
    
    private func setupPopUpMessage() -> EKPopUpMessage {
        let image = UIImage(named: "done")!.withRenderingMode(.alwaysTemplate)
        let title = "Awesome!"
        let description =
        """
        
        The movie/tv show was successfully added to your watch list!
        
        """
        
        let themeImage = EKPopUpMessage.ThemeImage(image: EKProperty.ImageContent(image: image, size: CGSize(width: 60, height: 60), tint: .white, contentMode: .scaleAspectFit))
        
        let titleLabel = EKProperty.LabelContent(text: title, style: .init(
            font: UIFont(name: "CodecPro-News", size: 30) ?? .systemFont(ofSize: 20),
            color: .white,
            alignment: .center))
        
        let descriptionLabel = EKProperty.LabelContent(text: description, style: .init(
            font: UIFont(name: "CodecPro-News", size: 20) ?? .systemFont(ofSize: 20),
            color: .white,
            alignment: .center))
        
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "OK",
                style: .init(
                    font: UIFont(name: "CodecPro-News", size: 20) ?? .systemFont(ofSize: 16),
                    color: .white
                )
            ),
            backgroundColor: .init(red: 12, green: 9, blue: 26),
            highlightedBackgroundColor: .clear
        )
        
        
        
        let message = EKPopUpMessage(themeImage: themeImage, title: titleLabel, description: descriptionLabel, button: button) {
            SwiftEntryKit.dismiss()
        }
        return message
    }
    
    private func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(light: UIColor(white: 1.0/255.0, alpha: 0.5), dark: UIColor(white: 1.0/255.0, alpha: 0.5)))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        
        attributes.entryBackground = .color(color: .init(red: 12, green: 9, blue: 26))
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(
            .init(cgColor: UIColor(red: 0.247, green: 0.216, blue: 0.498, alpha: 1).cgColor)), EKColor(.init(cgColor: UIColor(red: 0.263, green: 0.659, blue: 0.831, alpha: 1).cgColor))], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        
        attributes.roundCorners = .all(radius: 25)
        
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.2))
        )
        attributes.positionConstraints.verticalOffset = 10
        attributes.statusBar = .dark
        return attributes
    }
    
//    private func updateSavedWatchList() {
//        ObserveWatchList.shared.getMoviesID {
//            ObserveWatchList.shared.movieList.forEach { movie in
//                if movie == movieId {
//                    addToWatchListButton.setImage(UIImage(named: "bookmark_pressed"), for: .normal)
//                }
//            }
//        }
//        ObserveWatchList.shared.getTVShowsID {
//            ObserveWatchList.shared.tvShowList.forEach { tv in
//                if tv == tvShowId {
//                    addToWatchListButton.setImage(UIImage(named: "bookmark_pressed"), for: .normal)
//                }
//            }
//        }
//    }
    
    private func hideWatchListButton() {
        addToWatchListButton.isHidden = false
        if StorageSecure.keychain["guestID"] != nil {
            addToWatchListButton.isHidden = true
        }
    }
    
    private func setupUI() {
        let bgColor = UIColor(red: 0.05, green: 0.04, blue: 0.10, alpha: 1.00)
        self.bgDetailView.backgroundColor = bgColor
        collectionView.backgroundColor = .clear
        addToWatchListButton.setBackgroundImage(UIImage(named: "bookmark"), for: .normal)
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
                let removedZeros = movie.voteAverage
                let rateWithRemovedZeros = String(format: "%.1f", removedZeros ?? 0)
                voteCountLabel.text = (rateWithRemovedZeros)
                releaseDateLabel.text = attributedDate

                guard let movieGenresFilter = movie.genres else { return }
                var movieGenresCounter = ""
                for genre in movieGenresFilter {
                    movieGenresCounter += (genre.name ?? "") + " "
                }
                genreLabel.text = movieGenresCounter
            } else {
                guard let tvShow = viewModel.currentTVShow else { return }
                self.navigationItem.title = tvShow.name
                self.posterImageView.sd_setImage(with: URL(string: (MediaType.getImage.rawValue + (tvShow.posterPath ?? ""))), completed: nil)
                posterImageView.layer.cornerRadius = 25
                let attributedDate = formattedDateFromString(dateString: tvShow.firstAirDate ?? "", withFormat: "MMM dd, yyyy")
                titleLabel.text = (tvShow.name ?? tvShow.originalTitle ?? "")
                textView.text = tvShow.overview
                runtimeLabel.isHidden = true
                runtimeImageView.isHidden = true
                let removedZeros = tvShow.voteAverage
                let rateWithRemovedZeros = String(format: "%.1f", removedZeros ?? 0)
                voteCountLabel.text = (rateWithRemovedZeros)
                releaseDateLabel.text = attributedDate

                guard let tvGenresFilter = tvShow.genres else { return }
                var tvGenresCounter = ""
                for genre in tvGenresFilter {
                    tvGenresCounter += (genre.name ?? "") + " "
                }
                genreLabel.text = tvGenresCounter
            }
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
        let section = NSCollectionLayoutSection(group: group)
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
}

extension DetailViewController: UICollectionViewDelegate {}

