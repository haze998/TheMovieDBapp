//
//  CastModels.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 17.02.2023.
//

import Foundation

struct Cast : Codable {
    let adult : Bool?
    let gender : Int?
    let id : Int?
    let knownForDepartment : String?
    let name : String?
    let originalName : String?
    let popularity : Double?
    let profilePath : String?
    let castId : Int?
    let character : String?
    let creditId : String?
    let order : Int?
}
