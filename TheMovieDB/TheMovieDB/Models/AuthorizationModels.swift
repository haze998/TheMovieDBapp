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

// MARK: - GuestSessionID
struct GuestSessionID: Codable {
    let success: Bool
    let guestSessionID, expiresAt: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionID = "guest_session_id"
        case expiresAt = "expires_at"
    }
}
