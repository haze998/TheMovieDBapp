//
//  SearchTableViewCell.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.02.2023.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var rateLabel: UILabel!
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 200, height: 300), scaleMode: .fill)
    static let reuseID = "SearchTableViewCell"
    
    // MARK: - Configure SearchTableViewCell
    func configure(with media: MediaResponse.Media) {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(media.posterPath ?? "")")
        posterImageView.sd_setImage(with: url, placeholderImage: nil, context: [.imageTransformer : transformer], progress: nil)
        titleLabel.text = (media.title ?? media.originalTitle ?? "")
        textView.text = media.overview
        rateLabel.text = "\(media.voteAverage ?? 0)"
    }
}

