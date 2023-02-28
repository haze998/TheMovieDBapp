//
//  WatchListViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 14.02.2023.
//

import UIKit

class WatchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib(nibName: "WatchListTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "WatchListTableViewCell")
        }
    }
    var viewModel = WatchListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //goToAuthUser() - todo
        viewModel.fetchedWatchList {
            self.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        let bgColor = UIColor(red: 0.05, green: 0.04, blue: 0.10, alpha: 1.00)
        self.view.backgroundColor = bgColor
    }
}

extension WatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.moviesList.count
        } else {
            return viewModel.tvShowsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        guard let headerLabel = headerView.textLabel else { return }
        headerLabel.textColor = UIColor.white
        headerView.contentView.backgroundColor = UIColor(red: 0.05, green: 0.04, blue: 0.10, alpha: 1.00)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && !viewModel.moviesList.isEmpty {
            return "Movies"
        } else if section == 1 && !viewModel.tvShowsList.isEmpty {
            return "TV Shows"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WatchListTableViewCell", for: indexPath) as? WatchListTableViewCell else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let media = viewModel.moviesList[indexPath.row]
            cell.configure(with: media)
            return cell
        case 1:
            let media = viewModel.tvShowsList[indexPath.row]
            cell.configure(with: media)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension WatchListViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        switch indexPath.section {
        case 0:
            let media = viewModel.moviesList[indexPath.row]
            vc.movieId = media.id!
        case 1:
            let media = viewModel.tvShowsList[indexPath.row]
            vc.tvShowId = media.id!
        default:
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: "Remove") { _, _, completion in
            switch indexPath.section {
            case 0:
                self.viewModel.removeFetchedWatchList(mediaType: MediaType.movie.rawValue, mediaId: self.viewModel.moviesList[indexPath.row].id ?? 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    tableView.beginUpdates()
                    self.viewModel.moviesList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                    tableView.reloadData()
                }
            case 1:
                self.viewModel.removeFetchedWatchList(mediaType: MediaType.tvShow.rawValue, mediaId: self.viewModel.tvShowsList[indexPath.row].id ?? 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    tableView.beginUpdates()
                    self.viewModel.tvShowsList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                    tableView.reloadData()
                }
            default:
                return
            }
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [removeAction])
        return swipeActionConfig
    }
}
