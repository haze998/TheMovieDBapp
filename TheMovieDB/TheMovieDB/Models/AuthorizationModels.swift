//
//  AuthorizationModels.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.01.2023.
//

import Foundation

// MARK: - TokenResponseModel
struct TokenResponseModel: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

// MARK: - SessionIdResponse
struct SessionIdResponse: Codable {
    let success: Bool
    let sessionID: String

    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
