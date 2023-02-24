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
//        l
        segmentControl.addTarget(self, action: #selector(segmentWidget), for: .valueChanged)
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = createLayoutBuilder()
        
        let colorTop = UIColor(red: 0.33, green: 0.04, blue: 0.63, alpha: 1.00).cgColor
        let colorBot = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bgView.bounds
        gradientLayer.colors = [colorTop, colorBot]
        
        self.bgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func segmentWidget(sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
    private func createLayout() -> NSCollectionLayoutSection? {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(0.95))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 4,
                                                     bottom: 8,
                                                     trailing: 4)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(180),
                                               heightDimension: .absolute(280))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
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
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in return self.createLayout()
        }
    }
}

extension GenresViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let detailVC = DetailViewController()
      guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let genre = viewModel.sortedMovies.keys.sorted(by: <)[indexPath.section]
            let media = viewModel.sortedMovies[genre]![indexPath.item]
            //detailVC.movieId = media.id!
            vc.movieId = media.id!
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let genre = viewModel.sortedTVs.keys.sorted(by: <)[indexPath.section]
            let media = viewModel.sortedTVs[genre]![indexPath.item]
            //detailVC.tvShowId = media.id!
            vc.tvShowId = media.id!
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    
}

extension GenresViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return viewModel.sortedMovies.keys.count
        case 1:
            return viewModel.sortedTVs.keys.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0 :
            return viewModel.sortedMovies.values.count
        case 1:
            return viewModel.sortedTVs.values.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCollectionViewCell.reuseID, for: indexPath) as? GenresCollectionViewCell else { return UICollectionViewCell() }
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let genre = viewModel.sortedMovies.keys.sorted(by: <)[indexPath.section]
            let media = viewModel.sortedMovies[genre]![indexPath.item]
            cell.setupCell(media: media)
            return cell
        case 1:
            let genre = viewModel.sortedTVs.keys.sorted(by: <)[indexPath.section]
            let media = viewModel.sortedTVs[genre]![indexPath.item]
            cell.setupCell(media: media)
            return cell
        default:
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSectionCollectionViewCell.reuseId, for: indexPath) as? HeaderSectionCollectionViewCell else { return UICollectionReusableView() }
            switch segmentControl.selectedSegmentIndex {
            case 0:
                sectionHeader.label.text = viewModel.sortedMovies.keys.sorted(by: <)[indexPath.section]
                return sectionHeader
            case 1:
                sectionHeader.label.text = viewModel.sortedTVs.keys.sorted(by: <)[indexPath.section]
                return sectionHeader
            default:
                return sectionHeader
            }
        } else {
            return UICollectionReusableView()
        }
    }
}
