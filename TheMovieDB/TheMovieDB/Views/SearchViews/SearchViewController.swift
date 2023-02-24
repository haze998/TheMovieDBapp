//
//  SearchViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 14.02.2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            let nib = UINib(nibName: "SearchCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseId)
            collectionView.collectionViewLayout = createLayoutBuilder()
        }
    }
    
    
    private var searchActive : Bool = false
    var viewModel = SearchViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let colorTop = UIColor(red: 0.33, green: 0.04, blue: 0.63, alpha: 1.00).cgColor
        let colorBot = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorTop, colorBot]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .default
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        
    }
    
    private func createLayout() -> NSCollectionLayoutSection? {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 4,
                                                     bottom: 8,
                                                     trailing: 4)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 4,
                                                      bottom: 8,
                                                      trailing: 0)
//        //let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                heightDimension: .fractionalHeight(0.05))
//        //let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
//                                                                 elementKind: UICollectionView.elementKindSectionHeader,
//                                                                 alignment: .topLeading)
        let section = NSCollectionLayoutSection(group: group)
        //section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 0
        return section
    }
    
    private func createLayoutBuilder() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in return self.createLayout()
        }
    }
}

// MARK: - UISearchBarDelegate Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            if searchBar.text == "" {
                DispatchQueue.main.async {
                    self.viewModel.searchedMedia.removeAll()
                    self.collectionView.reloadData()
                }
            } else {
                guard let query = searchBar.text else { return }
                self.viewModel.searchedMedia.removeAll()
                self.viewModel.currentPage = 0
                //          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                viewModel.searchMovie(query: query) {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        case 1:
            if searchBar.text == "" {
                DispatchQueue.main.async {
                    self.viewModel.searchedMedia.removeAll()
                    self.collectionView.reloadData()
                }
            } else {
                guard let query = searchBar.text else { return }
                self.viewModel.searchedMedia.removeAll()
                self.viewModel.currentPage = 0
                //          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                viewModel.searchTV(query: query) {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        default:
            return
        }
        
    }
}

// MARK: - CollectionView DataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searchedMedia.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseId, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
         cell.configure(with: viewModel.searchedMedia[indexPath.row])
        return cell
    }
    
    // - MARK: Choosen movie/tv to detail VC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.searchTextField.endEditing(true)
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //let detailVC = DetailViewController()
            guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
            vc.movieId = viewModel.searchedMedia[indexPath.row].id!
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //let detailVC = DetailViewController()
            guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
            vc.tvShowId = viewModel.searchedMedia[indexPath.row].id!
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    // - MARK: Paggination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let query = searchBar.text else { return }
        if viewModel.currentPage < viewModel.totalPages && indexPath.row == viewModel.searchedMedia.count - 1 {
            viewModel.searchMovie(query: query) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }

    }
}

// MARK: - TableView Delegate
extension SearchViewController: UICollectionViewDelegate { }
