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
    @IBOutlet weak var stackView: UIStackView!
    static let reuseID = "GenresCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupCell(media: MediaResponse.Media) {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(media.posterPath ?? "")")
        movieImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
         movieImageView.sd_setImage(with: url, placeholderImage: nil, progress: nil) { [ weak self ] _, _, _, _ in
            guard let self = self else { return }
            self.rateMovieLabel.text = "\(media.voteAverage ?? 0)"
        }
    }
    
    // MARK: - Configure UI
    private func setupUI() {
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        stackView.layer.cornerRadius = 5
    }
}

