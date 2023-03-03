//
//  WatchListTableViewCell.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 26.02.2023.
//

import UIKit
import SDWebImage

class WatchListTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textOverview: UITextView!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
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
            self.textOverview.text = media.overview
        }
    }
    
}
