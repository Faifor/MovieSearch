//
//  MovieService.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 24.05.2025.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchGenres(completion: @escaping (Result<[String], Error>) -> Void)
    func fetchMovies(page: Int, sortOrder: MoviesViewViewModel.SortOrder, selectedGenres: Set<String>, completion: @escaping (Result<ServerResponse, Error>) -> Void)
    func searchMovies(query: String, page: Int, completion: @escaping (Result<ServerResponse, Error>) -> Void)
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetailModel, Error>) -> Void)
}

final class MovieService: MovieServiceProtocol {
    
    func fetchGenres(completion: @escaping (Result<[String], Error>) -> Void) {
        APIManager.shared.request(
            endpoint: .genres,
            query: ["field": "genres.name"],
            decodeTo: [GenreItem].self
        ) { result in
            switch result {
            case .success(let genres):
                let names = genres.map { $0.name }.sorted()
                completion(.success(names))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovies(page: Int, sortOrder: MoviesViewViewModel.SortOrder, selectedGenres: Set<String>, completion: @escaping (Result<ServerResponse, Error>) -> Void) {
        var query: [String: String] = [
            "page": "\(page)",
            "limit": "10",
            "notNullFields": "poster.url"
        ]
        
        if let field = sortOrder.apiSortField {
            query["sortField"] = field
            query["sortType"] = "\(sortOrder.apiSortType)"
        }
        
        for genre in selectedGenres {
            query["genres.name"] = genre
        }
        
        APIManager.shared.request(
            endpoint: .movies,
            query: query,
            decodeTo: ServerResponse.self,
            completion: completion
        )
    }
    
    func searchMovies(query: String, page: Int, completion: @escaping (Result<ServerResponse, Error>) -> Void) {
        APIManager.shared.request(
            endpoint: .search,
            query: [
                "query": query,
                "page": "\(page)"
            ],
            decodeTo: ServerResponse.self,
            completion: completion
        )
    }
    
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetailModel, Error>) -> Void) {
        APIManager.shared.request(
            endpoint: .movieDetail(id: id),
            decodeTo: MovieDetailModel.self,
            completion: completion
        )
    }
}
