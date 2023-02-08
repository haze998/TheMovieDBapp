//
//  AuthorizationViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 23.01.2023.
//

import Foundation

// MARK: - AuthorizationViewModel
class AuthorizationViewModel {
    
    var isLogin: Bool = false
    
    func userInfo(userName: String, pass: String, completion: @escaping () -> Void) {
        if userName.isEmpty || pass.isEmpty {
            print("auth error")
        } else {
            AuthNetworkManager.shared.getToken(userName: userName, password: pass) { [weak self] authResult in
                guard let self = self else { return }
                self.isLogin = authResult
                completion()
            }
           
        }
    }
    
//    func guestSignIn(_ completionHandler: @escaping () -> Void) {
//            AuthNetworkManager.shared.guestSession ({ [weak self] guestSession in
//                guard let self = self else { return }
//                self.isLogin = guestSession.success
//                completionHandler()
//            })
//    }
}
