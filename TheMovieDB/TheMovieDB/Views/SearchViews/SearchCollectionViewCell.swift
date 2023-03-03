//
//  SearchCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 23.02.2023.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    static let reuseId = "SearchCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 0
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        stackView.layer.cornerRadius = 5
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
    }
    
    func configure(with media: MediaResponse.Media) {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(media.posterPath ?? "")")
        posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        posterImageView.sd_setImage(with: url, placeholderImage: nil, progress: nil) { [ weak self ] _, _, _, _ in
            guard let self = self else { return }
            let removedZeros = media.voteAverage
            let rateWithRemovedZeros = String(format: "%.1f", removedZeros ?? 0)
            self.rateLabel.text = rateWithRemovedZeros
            self.titleLabel.text = (media.title ?? media.originalTitle ?? "")
        }
    }

}
