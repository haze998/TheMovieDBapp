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
            OnboardingSlideModel(title: "Everything about movies, series, anime and much more.", description: "Stay on top of information about movies, series, anime and more.", animationName: "girlsMovie"),
            OnboardingSlideModel(title: "Everything about movies, series, anime and much more.", description: "Stay on top of information about movies, series, anime and more.", animationName: "camera"),
            OnboardingSlideModel(title: "Everything about movies, series, anime and much more.", description: "Stay on top of information about movies, series, anime and more.", animationName: "movieMan"),
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
            UIColor(red: 0.5, green: 0, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.329, green: 0.043, blue: 0.631, alpha: 1).cgColor
        ]
        gradientButton.frame = getStartedButton.bounds
        getStartedButton.layer.insertSublayer(gradientButton, at: 0)
        getStartedButton.layer.cornerRadius = 20
        getStartedButton.layer.masksToBounds = true
        getStartedButton.titleLabel?.font = UIFont(name: "CodecPro-News", size: 20.0)
        
        //background gradient
        let colorTop =  UIColor(red: 0.188, green: 0.196, blue: 0.262, alpha: 1).cgColor
        let colorBot =   UIColor(red: 0.239, green: 0.271, blue: 0.562, alpha: 1).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bgView.bounds
        gradientLayer.colors = [colorTop, colorBot]
        self.bgView.layer.insertSublayer(gradientLayer, at: 0)
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
