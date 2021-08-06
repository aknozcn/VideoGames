//
//  GameDetailsViewModel.swift
//  VideoGames
//
//  Created by Akin O. on 4.08.2021.
//

import Foundation

protocol GameDetailsVMDelegate {
    func fetched(response: GameDetailsResponse)
    func checkFavoritesGame(status: Bool)
}

class GameDetailsViewModel {
    
    private let apiManager = APIManager()
    private let manager: CoreDataManager = CoreDataManager()

    var delegate: GameDetailsVMDelegate?
    
    func getGameDetails(gameId: Int) {
        apiManager.fetchGameDetails(id: gameId) { (result) in
            switch result {
            case .success(let data):
                self.delegate?.fetched(response: data)
                print("success: \(data)")
            case .failure(let error):
                print("error getGameDetails: \(error.localizedDescription)")
            }

        }
    }
    
    func checkFavoritesGame(gameId: Int){
        if manager.checkExistsGameId(byId: gameId) {
            self.delegate?.checkFavoritesGame(status: true)
        } else {
            self.delegate?.checkFavoritesGame(status: false)
        }
    }
    
    func deleteFavoritesGame(gameId: Int) {
        if manager.deleteGameId(id: gameId) {
            checkFavoritesGame(gameId: gameId)
        }
    }
}
