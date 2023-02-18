//
//  DetailCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 17.02.2023.
//

import UIKit
import SDWebImage

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var actorNamelabel: UILabel!
    var viewModel = DetailViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(actor: Cast) {
//        if let imagePath = actor.profilePath {
//            let movieImageUrl = "https://image.tmdb.org/t/p/original" + imagePath
//            let url = URL(string: movieImageUrl)
//            actorImageView.sd_setImage(with: url)
//        } else {
//            print("error loading")
//        }
        if let imagePath = actor.profilePath {
            let movieImageUrl = "https://image.tmdb.org/t/p/original" + imagePath
            let url = URL(string: movieImageUrl)
            actorImageView.sd_setImage(with: url)
            } else {
            actorImageView.image = UIImage(named: "defaultImage")
 }
        //let url = URL(string: "https://image.tmdb.org/t/p/original" + (actor.profilePath ?? ""))
        //actorImageView.sd_setImage(with: url, placeholderImage: nil, progress: nil)
        actorNamelabel.text = actor.name
    }

}

