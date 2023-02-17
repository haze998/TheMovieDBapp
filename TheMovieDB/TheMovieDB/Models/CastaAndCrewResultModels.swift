//
//  CrewModels.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 17.02.2023.
//

import Foundation

struct CastAndCrewResult : Codable {
    let id : Int?
    let cast : [Cast]?
    let crew : [Crew]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case cast = "cast"
        case crew = "crew"
    }
}
