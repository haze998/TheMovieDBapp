//
//  DetailCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 17.02.2023.
//

import UIKit
import SDWebImage

class DetailCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var actorNamelabel: UILabel!
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 200, height: 200), scaleMode: .aspectFill)
    var viewModel = DetailViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(actor: Cast) {
        if let imagePath = actor.profilePath {
            let movieImageUrl = "https://image.tmdb.org/t/p/original" + imagePath
            let url = URL(string: movieImageUrl)
            actorImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            actorImageView.sd_setImage(with: url, placeholderImage: nil, context: [.imageTransformer : transformer], progress: nil)
            } else {
            actorImageView.image = UIImage(named: "defaultImage")
 }
        actorNamelabel.text = actor.name
    }
    
    func setupUI() {
        actorImageView.contentMode = .scaleAspectFill
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
    }

}

