//
//  MovieService.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 24.05.2025.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchGenres() async throws -> [String]
    func fetchMovies(page: Int, sortOrder: MoviesViewViewModel.SortOrder, selectedGenres: Set<String>) async throws -> ServerResponse
    func searchMovies(query: String, page: Int) async throws -> ServerResponse
    func fetchMovieDetail(id: Int) async throws -> MovieDetailModel
}

final class MovieService: MovieServiceProtocol {
    
    func fetchGenres() async throws -> [String] {
        let genres = try await APIManager.shared.request (
            endpoint: .genres,
            query: ["field": "genres.name"],
            decodeTo: [GenreItem].self
        )
        return genres.map { $0.name }.sorted()
    }
    
    func fetchMovies(page: Int, sortOrder: MoviesViewViewModel.SortOrder, selectedGenres: Set<String>) async throws -> ServerResponse {
        var query: [String: String] = [
            "page": "\(page)",
            "limit": "10",
            "notNullFields": "poster.url"
        ]

        if let field = sortOrder.apiSortField {
            query["sortField"] = field
            query["sortType"] = "\(sortOrder.apiSortType)"
        }

        if let genre = selectedGenres.first {
            query["genres.name"] = genre
        }

        return try await APIManager.shared.request(
            endpoint: .movies,
            query: query,
            decodeTo: ServerResponse.self
        )
    }

    
    func searchMovies(query: String, page: Int) async throws -> ServerResponse {
        return try await APIManager.shared.request(
            endpoint: .search,
            query: [
                "query": query,
                "page": "\(page)"
            ],
            decodeTo: ServerResponse.self
        )
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetailModel {
        return try await APIManager.shared.request(
            endpoint: .movieDetail(id: id),
            decodeTo: MovieDetailModel.self
        )
    }
}
