//
//  AuthorizationViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 23.01.2023.
//

import UIKit

class AuthorizationViewModel {
//    var networkManager = AuthNetworkManager()
    
    func userInfo(userName: String, pass: String) {
        AuthNetworkManager.shared.getToken(userName: userName, password: pass)
    }
}
