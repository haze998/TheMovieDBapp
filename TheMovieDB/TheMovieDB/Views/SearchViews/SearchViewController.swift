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
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: SearchTableViewCell.reuseID)
        }
    }
    private var searchActive : Bool = false
    var viewModel = SearchViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
    }
}

// MARK: - UISearchBarDelegate Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.searchMovie(query: searchText) {
//            self.tableView.reloadData()
//        }
        if searchBar.text!.count >= 3 {
            guard let query = searchBar.text else { return }
            if query.isEmpty {
                viewModel.searchedMedia.removeAll()
                tableView.reloadData()
            }
            
            self.viewModel.currentPage = 0
            viewModel.searchMovie(query: query) {
                    self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.searchedMedia[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate { }
