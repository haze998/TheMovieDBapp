//
//  OnboardViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.01.2023.
//

import UIKit
import Lottie

class OnboardViewController: UIViewController {
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            let nib = UINib(nibName: OnboardingCollectionViewCell.id, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: OnboardingCollectionViewCell.id)
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: UIButton!
    var slides: [OnboardingSlideModel] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                getStartedButton.setTitle("Get Started!", for: .normal)
            } else {
                getStartedButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        slides = [
            OnboardingSlideModel(title: "The best way to have a good time is to watch a cool movie.", description: "So grab something yummy and make yourself comfortable.", animationName: "girlsMovie"),
            OnboardingSlideModel(title: "You'll find everything about movies, TV shows, anime, and much more.", description: "Stay on top of information about movies, TV shows, anime, and more.", animationName: "camera"),
            OnboardingSlideModel(title: "We'll help you brighten up your evening with our app.", description: "A huge collection of movies, daily top updates and much more you'll find in the TMDB app.", animationName: "movieMan"),
        ]
    }
    
    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        
        if currentPage == slides.count - 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "AuthorizationViewController") as? AuthorizationViewController else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true)
            
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func setupUI() {
        
        // button
        let gradientButton = CAGradientLayer()
        gradientButton.colors = [
            UIColor(red: 0.247, green: 0.216, blue: 0.498, alpha: 1).cgColor,
            UIColor(red: 0.263, green: 0.659, blue: 0.831, alpha: 1).cgColor
          ]
        gradientButton.locations = [0, 1]
        gradientButton.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientButton.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientButton.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1.14, b: 1.43, c: -1.43, d: -87.17, tx: 1.85, ty: 43.16))
        gradientButton.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        gradientButton.position = view.center
        
        getStartedButton.layer.insertSublayer(gradientButton, at: 0)
        getStartedButton.layer.cornerRadius = 20
        getStartedButton.layer.masksToBounds = true
        getStartedButton.titleLabel?.font = UIFont(name: "CodecPro-News", size: 20.0)
        
        //background color
//        let colorTop = UIColor(red: 0.33, green: 0.04, blue: 0.63, alpha: 1.00).cgColor
//        let colorBot = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bgView.bounds
//        gradientLayer.colors = [colorTop, colorBot]
//        self.bgView.layer.insertSublayer(gradientLayer, at: 0)
        let bgColor = UIColor(red: 0.05, green: 0.04, blue: 0.10, alpha: 1.00)
        self.view.backgroundColor = bgColor
    }
}

extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.id, for: indexPath) as? OnboardingCollectionViewCell else { return  OnboardingCollectionViewCell() }
        cell.configure(slides[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
