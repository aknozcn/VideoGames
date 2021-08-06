//
//  APIManager.swift
//  VideoGames
//
//  Created by Akin O. on 3.08.2021.
//

import Foundation
import Moya

class APIManager {

    var provider = MoyaProvider<APIRequest>(plugins: [NetworkLoggerPlugin()])

    func fetchGames(completion: @escaping (Result<GamesResponse, Error>) -> ()) {
        request(target: .getGames, completion: completion)
    }
    func fetchGameDetails(id: Int, completion: @escaping (Result<GameDetailsResponse, Error>) -> ()) {
        request(target: .getGameDetails(id: id), completion: completion)
    }

    func request<T: Decodable>(target: APIRequest, completion: @escaping(Result<T, Error>) -> ()) {

        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
