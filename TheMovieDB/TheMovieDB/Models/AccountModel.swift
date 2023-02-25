//
//  AccountModel.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 25.02.2023.
//

import Foundation

// MARK: - AccountModel
struct Account: Codable {
    let id: Int?
    let name: String?
    let includeAdult: Bool?
    let username: String?
}
