//
//  GamesViewModel.swift
//  VideoGames
//
//  Created by Akin O. on 3.08.2021.
//

import Foundation

protocol GamesVMDelegate {
    func fetched(response: GamesResponse)
}

class GamesViewModel {
    
    private let apiManager = APIManager()

    var delegate: GamesVMDelegate?
    
    func getGames() {
        apiManager.fetchGames() { (result) in
            switch result {
            case .success(let data):
                self.delegate?.fetched(response: data)
                print("success: \(data)")
            case .failure(let error):
                print("error getGames: \(error.localizedDescription)")
            }

        }
    }
}
