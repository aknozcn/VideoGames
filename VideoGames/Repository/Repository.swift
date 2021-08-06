//
//  Repository.swift
//  VideoGames
//
//  Created by Akin O. on 4.08.2021.
//

import Foundation

protocol Repository {
    func create(gameId: Int) -> Bool
    func getAll() -> [String]?
    func delete(id: Int) -> Bool
    func checkExistsGameId(byId id: Int) -> Bool
}
