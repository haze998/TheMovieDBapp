//
//  AuthorizationViewModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 23.01.2023.
//

import Foundation
import KeychainAccess

// MARK: - AuthorizationViewModel
class AuthorizationViewModel {
    
    var isLogin: Bool = false
    
    // MARK: Guest ID
    func getGuestSessionID() {
        AuthNetworkManager.shared.getGuestSessionID { session in
            if let session = session.guestSessionID {
                do {
                    try StorageSecure.keychain.set(session, key: "guestID")
                } catch {
                    print("Unavailable set guest ID")
                }
            }
        }
        StorageSecure.keychain["sessionID"] = nil
        StorageSecure.keychain["accountID"] = nil
    }
    
    // MARK: Authentification
    func userAuthentication(username: String, password: String, completion: @escaping ((Bool) -> Void)) {
        AuthNetworkManager.shared.getRequestToken { result in
            guard let token = result.requestToken else { return }
            AuthNetworkManager.shared.getValidateRequestToken(login: username, password: password, requestToken: token) { result in
                AuthNetworkManager.shared.createSessionId(requestToken: result.requestToken ?? "") { success in
                    if let id = success.sessionID {
                        do {
                            try StorageSecure.keychain.set(id, key: "sessionID")
                        } catch {
                            print("Unavailable set session ID")
                        }
                    }
                    if let success = success.success {
                        completion(success)
                    }
                }
            }
            
        }
        
    }
    
    // MARK: Account ID
    func getAccountID(_ sessionID: String) {
        AuthNetworkManager.shared.getAccount(sessionID: sessionID) { account in
            if let id = account.id {
                do {
                    try StorageSecure.keychain.set(String(id), key: "accountID")
                } catch {
                    print("Unavailable set accound ID")
                }
            }
        }
    }
}
