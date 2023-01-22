//
//  AuthorizationViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.01.2023.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    var networkManager = AuthNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.getToken()
    }
}
