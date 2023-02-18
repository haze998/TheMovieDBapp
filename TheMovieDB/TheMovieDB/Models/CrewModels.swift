//
//  CrewModels.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 17.02.2023.
//

import Foundation

struct Crew : Codable {
    let adult : Bool?
    let gender : Int?
    let id : Int?
    let knownForDepartment : String?
    let name : String?
    let originalName : String?
    let popularity : Double?
    let profilePath : String?
    let creditId : String?
    let department : String?
    let job : String?
    
    enum CodingKeys: String, CodingKey {
        
        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
        case creditId = "credit_id"
        case department = "department"
        case job = "job"
    }
}
