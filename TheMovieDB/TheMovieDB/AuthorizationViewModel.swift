//
//  AuthorizationViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 23.01.2023.
//

import Foundation

class AuthorizationViewModel {
    
    var isLogin: Bool = false
    
    func userInfo(userName: String, pass: String, completion: @escaping () -> Void) {
        if userName.isEmpty || pass.isEmpty {
            print("auth error")
        } else {
            AuthNetworkManager.shared.getToken(userName: userName, password: pass) { authResult in
                self.isLogin = authResult
                completion()
            }
           
        }
    }
}
