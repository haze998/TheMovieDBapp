//
//  GenresCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 03.02.2023.
//

import UIKit
import SDWebImage

class GenresCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var rateMovieLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    private let sdwTransformer = SDImageResizingTransformer(size: CGSize(width: 200, height: 300), scaleMode: .fill)
    static let reuseID = "GenresCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupUI()
    }
    
    func setupCell(media: MediaResponse.Media) {
        loadingIndicator.startAnimating()
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(media.posterPath ?? "")")
        movieImageView.sd_setImage(with: url, placeholderImage: nil, context: [.imageTransformer: sdwTransformer], progress: nil) { [ weak self ] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            self.rateMovieLabel.text = "\(media.voteAverage ?? 0)"
            
        }
    }
    
    // MARK: - Configure UI
    private func setupUI() {
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        stackView.layer.cornerRadius = 5
    }
}

