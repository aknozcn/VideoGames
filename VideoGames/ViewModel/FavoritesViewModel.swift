//
//  FavoritesViewModel.swift
//  VideoGames
//
//  Created by Akin O. on 5.08.2021.
//

import Foundation

protocol FavoritesVMDelegate {
    func fetched(response: GamesResponse)
    func gameIdFetched(data: [String]?)
}

class FavoritesViewModel {
    
    private let apiManager = APIManager()
    private let manager: CoreDataManager = CoreDataManager()

    var delegate: FavoritesVMDelegate?
    
    func getGames() {
        apiManager.fetchGames() { (result) in
            switch result {
            case .success(let data):
                self.delegate?.fetched(response: data)
                self.getGameId()
                print("success: \(data)")
            case .failure(let error):
                print("error getGames: \(error.localizedDescription)")
            }
        }
    }
    
    func getGameId(){
        
        let gameId = manager.fetchGameId()
        
        self.delegate?.gameIdFetched(data: gameId)
    }
}

