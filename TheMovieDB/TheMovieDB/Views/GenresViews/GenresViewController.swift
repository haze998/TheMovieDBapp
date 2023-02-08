//
//  GenresViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 28.01.2023.
//

import UIKit

class GenresViewController: UIViewController {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            let nib = UINib(nibName: GenresCollectionViewCell.reuseID, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: GenresCollectionViewCell.reuseID)
            collectionView.register(HeaderSectionCollectionViewCell.self,
                                   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                   withReuseIdentifier: HeaderSectionCollectionViewCell.reuseId)
        }
    }
    var viewModel = GenresViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.getSortedMovies {
            self.collectionView.reloadData()
        }
        viewModel.getSortedTVs {
            self.collectionView.reloadData()
        }
    }
    
    func setupUI() {
        segmentControl.setTitle("Movies", forSegmentAt: 0)
        segmentControl.setTitle("TV Shows", forSegmentAt: 1)
        segmentControl.backgroundColor = .clear
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = createLayoutBuilder()
        
        let colorTop =  UIColor(red: 0.188, green: 0.196, blue: 0.262, alpha: 1).cgColor
        let colorBot =   UIColor(red: 0.239, green: 0.271, blue: 0.562, alpha: 1).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bgView.bounds
        gradientLayer.colors = [colorTop, colorBot]
        self.bgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
   private func createLayout() -> NSCollectionLayoutSection? {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                         leading: 4,
                                                         bottom: 8,
                                                         trailing: 4)
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180),
                                                   heightDimension: .absolute(330))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                          leading: 4,
                                                          bottom: 8,
                                                          trailing: 0)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(0.05))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .topLeading)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
        }
    
    private func createLayoutBuilder() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            return self.createLayout()
        }
    }
    

}

extension GenresViewController: UICollectionViewDelegate { }

extension GenresViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sortedMovies.keys.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sortedMovies.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCollectionViewCell.reuseID, for: indexPath) as? GenresCollectionViewCell else { return UICollectionViewCell() }
        let genre = viewModel.sortedMovies.keys.sorted(by: <)[indexPath.section]
        let media = viewModel.sortedMovies[genre]![indexPath.item]
        cell.setupCell(media: media)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSectionCollectionViewCell.reuseId, for: indexPath) as? HeaderSectionCollectionViewCell else { return UICollectionReusableView() }
            
            sectionHeader.label.text = viewModel.sortedMovies.keys.sorted(by: <)[indexPath.section]

            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
        
    }
}
