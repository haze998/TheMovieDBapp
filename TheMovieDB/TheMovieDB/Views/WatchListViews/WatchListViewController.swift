//
//  WatchListViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 14.02.2023.
//

import UIKit
import SwiftEntryKit

class WatchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib(nibName: "WatchListTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "WatchListTableViewCell")
        }
    }
    private var viewModel = WatchListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goToAuthUser()
        viewModel.getRealmMedia()
        viewModel.fetchedWatchList {
            self.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        let bgColor = UIColor(red: 0.05, green: 0.04, blue: 0.10, alpha: 1.00)
        self.view.backgroundColor = bgColor
    }
    
    private func goToAuthUser() {
        if StorageSecure.keychain["guestID"] != nil {
            SwiftEntryKit.display(entry: PopUpView(with: setupPopUpMessage()), using: setupAttributes())
        }
    }
    
    private func setupPopUpMessage() -> EKPopUpMessage {
        let image = UIImage(named: "key")!.withRenderingMode(.alwaysTemplate)
        let title = "NO ACCES"
        let description =
        """
        
        You must be authorized to access the Watch List!
        
        """
        
        let themeImage = EKPopUpMessage.ThemeImage(image: EKProperty.ImageContent(image: image, size: CGSize(width: 60, height: 60), tint: .white, contentMode: .scaleAspectFit))
        
        let titleLabel = EKProperty.LabelContent(text: title, style: .init(
            font: UIFont(name: "CodecPro-News", size: 30) ?? .systemFont(ofSize: 20),
            color: .white,
            alignment: .center))
        
        let descriptionLabel = EKProperty.LabelContent(text: description, style: .init(
            font: UIFont(name: "CodecPro-News", size: 20) ?? .systemFont(ofSize: 20),
            color: .white,
            alignment: .center))
        
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "OK",
                style: .init(
                    font: UIFont(name: "CodecPro-News", size: 20) ?? .systemFont(ofSize: 16),
                    color: .white
                )
            ),
            backgroundColor: .init(red: 12, green: 9, blue: 26),
            highlightedBackgroundColor: .clear
        )
        
        let message = EKPopUpMessage(themeImage: themeImage, title: titleLabel, description: descriptionLabel, button: button) {
            SwiftEntryKit.dismiss()
        }
        return message
    }
    
    private func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(light: UIColor(white: 1.0/255.0, alpha: 0.5), dark: UIColor(white: 1.0/255.0, alpha: 0.5)))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        
        attributes.entryBackground = .color(color: .init(red: 12, green: 9, blue: 26))
        attributes.entryBackground = .color(color: .init(.red))
        
        attributes.roundCorners = .all(radius: 25)
        
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.2))
        )
        attributes.positionConstraints.verticalOffset = 10
        attributes.statusBar = .dark
        return attributes
    }
}

extension WatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.moviesList.count
        } else if section == 1 {
            return viewModel.tvShowsList.count
        } else {
            return viewModel.realmList.count
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
        } else if section == 2 && !viewModel.realmList.isEmpty {
            return "Realm Storage"
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
        case 2:
            let media = viewModel.realmList[indexPath.row]
            cell.configureRealm(with: media)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension WatchListViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
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
            case 2:

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    tableView.beginUpdates()
                    self.viewModel.removeRealmMedia(media: self.viewModel.realmList[indexPath.row])
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                    tableView.reloadData()
                }
            default:
                return
            }
        }
        removeAction.image = UIImage(named: "trash")
        removeAction.backgroundColor = UIColor(red: 12, green: 9, blue: 26, alpha: 0)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [removeAction])
        return swipeActionConfig
    }
}
