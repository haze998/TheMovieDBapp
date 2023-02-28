//
//  TabBarViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 14.02.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
        
    }
    
    private func setupUI() {
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        logoutUser()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthorizationViewController")
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
        print("Session deleted")
    }
    private func logoutUser() {
        if let session = StorageSecure.keychain["sessionID"] {
            AuthNetworkManager.shared.deleteSession(sessionID: session)
        }
        StorageSecure.keychain["guestID"] = nil
        StorageSecure.keychain["sessionID"] = nil
        StorageSecure.keychain["accountID"] = nil
    }
}
