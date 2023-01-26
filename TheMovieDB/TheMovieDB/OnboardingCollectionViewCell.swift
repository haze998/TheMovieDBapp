//
//  OnboardingCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 25.01.2023.
//

import UIKit
import Lottie

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    static let id = "OnboardingCollectionViewCell"
    
    func configure(_ slide: OnboardingSlideModel) {
        titleLabel.text = slide.title
        descriptionLabel.text = slide.description
        animationView.animation = .named(slide.animationName)
        animationView.loopMode = .loop
        animationView.play()
    }
}
