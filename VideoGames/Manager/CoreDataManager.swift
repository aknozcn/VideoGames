//
//  CoreDataManager.swift
//  VideoGames
//
//  Created by Akin O. on 4.08.2021.
//

import Foundation

struct CoreDataManager {

    private let _coreDataRepository = CoreDataRepository()

    func createGameId(gameId: Int) -> Bool {
        return _coreDataRepository.create(gameId: gameId)
    }
    
    func fetchGameId() -> [String]? {
        return _coreDataRepository.getAll()
    }

    func deleteGameId(id: Int) -> Bool {
        return _coreDataRepository.delete(id: id)
    }

    func checkExistsGameId(byId id: Int) -> Bool {
        return _coreDataRepository.checkExistsGameId(byId: id)
    }
}
