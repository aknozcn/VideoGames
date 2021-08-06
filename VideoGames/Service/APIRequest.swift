//
//  APIRequest.swift
//  VideoGames
//
//  Created by Akin O. on 3.08.2021.
//

import Foundation
import Moya

enum APIConstants {
    public static let baseUrl = "https://api.rawg.io/api"
    public static let apiKey = "cf03345fc3874b2aaca2084d6da69245"
}

enum APIRequest {
    case getGames
    case getGameDetails(id: Int)
}

extension APIRequest: TargetType {

    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseUrl) else { fatalError() }
        return url
    }

    var path: String {
        switch self {
        case .getGames:
            return "games"
        case .getGameDetails(let id):
            return "games/\(id)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getGames:
            let params = ["key": APIConstants.apiKey] as [String : Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .getGameDetails:
            let params = ["key": APIConstants.apiKey] as [String : Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

