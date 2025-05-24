//
//  Endpoint.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 24.05.2025.
//

import Foundation

enum Endpoint {
    case movies
    case movieDetail(id: Int)
    case search
    case genres

    var path: String {
        switch self {
        case .movies:
            return "/v1.4/movie"
        case .movieDetail(let id):
            return "/v1.4/movie/\(id)"
        case .search:
            return "/v1.4/movie/search"
        case .genres:
            return "/v1/movie/possible-values-by-field"
        }
    }
}
