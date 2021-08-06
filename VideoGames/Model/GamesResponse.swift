//
//  GamesResponse.swift
//  VideoGames
//
//  Created by Akin O. on 3.08.2021.
//

import Foundation

struct GamesResponse: Codable {

    var results: [GameResult]

    enum CodingKeys: String, CodingKey {
        case results

    }
}

struct GameResult: Codable {
    let id: Int
    let name, released: String
    let backgroundImage: String
    let metacritic: Int
   

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case metacritic
    }
}
