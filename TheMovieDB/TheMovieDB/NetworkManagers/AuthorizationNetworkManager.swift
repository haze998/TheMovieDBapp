//
//  AuthorizationNetworkManager.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.01.2023.
//

import Foundation
import Alamofire

class AuthNetworkManager {
    static let shared = AuthNetworkManager()
    
    private init() {}
    
    var url = "https://api.themoviedb.org/3/authentication/token/new?api_key=aef19f83a7261debd6b9b8edfd7919ce"
    
    func getToken(userName: String, password: String, completion: @escaping(Bool) -> Void){
        let request = AF.request(url, method: .get)
        request.responseDecodable(of: TokenResponseModel.self) { [weak self] response in
            do {
                let token = try response.result.get().requestToken
                self?.getValidateRequestToken(username: userName.self, password: password.self, requestToken: token)
                completion(try response.result.get().success)
            } catch {
                print(error)
            }
        }
    }
    
    func getValidateRequestToken(username: String, password: String, requestToken: String) {
        let url = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=aef19f83a7261debd6b9b8edfd7919ce"
        let parameters: [String: Any] = ["username" : username,
                                         "password" : password,
                                         "request_token": requestToken]
        let request = AF.request(url, method: .post, parameters: parameters)
        request.responseDecodable(of: TokenResponseModel.self) { response in
            do {
                let token = try response.result.get().requestToken
                print("Validate \(token)")
                self.getSessionId(requestToken: token)
            } catch {
                print(error)
            }
        }
    }
    
    func getSessionId(requestToken: String) {
        let url = "https://api.themoviedb.org/3/authentication/session/new?api_key=aef19f83a7261debd6b9b8edfd7919ce"
        let parameters: [String: Any] = ["request_token": requestToken]
        let request = AF.request(url, method: .post, parameters: parameters)
        request.responseDecodable(of: SessionIdResponse.self) { response in
            do {
                let sessionId = try response.result.get().sessionID
                print("SessionId: \(sessionId)")
            } catch {
                print(error)
            }
        }
    }
}
