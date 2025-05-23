//
//  MoviesViewViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 16.04.2025.
//
import Foundation
import Combine

class MoviesViewViewModel: ObservableObject {
    
    enum SortOrder: String, CaseIterable, Identifiable {
        case none
        case nameAsc = "name_asc"
        case nameDesc = "name_desc"
        case ratingAsc = "rating.kp_asc"
        case ratingDesc = "rating.kp_desc"

        var id: String { rawValue }

        var apiSortField: String? {
            switch self {
            case .none: return nil
            case .nameAsc, .nameDesc: return "name"
            case .ratingAsc, .ratingDesc: return "rating.kp"
            }
        }

        var apiSortType: Int {
            switch self {
            case .none: return 1
            case .nameAsc, .ratingAsc: return 1
            case .nameDesc, .ratingDesc: return -1
            }
        }

        var description: String {
            switch self {
            case .none: return "Без сортировки"
            case .nameAsc: return "Имя ↑"
            case .nameDesc: return "Имя ↓"
            case .ratingAsc: return "Рейтинг ↑"
            case .ratingDesc: return "Рейтинг ↓"
            }
        }
    }

    @Published var movies: [MovieModel] = []
    @Published var currentPage = 1
    @Published var totalPages = 1
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isGenreSelectionDirty: Bool = false

    
    @Published var genres: [String] = []
    @Published var selectedGenres: Set<String> = []
    
    @Published var sortOrder: SortOrder = .none {
        didSet { if !isSearching { refreshMovies() } }
    }
    
    @Published var searchText: String = ""
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func loadGenres() {
        APIManager.shared.request(
            path: "/v1/movie/possible-values-by-field",
            query: ["field": "genres.name"],
            decodeTo: [GenreItem].self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let genres):
                    self.genres = genres.map { $0.name }.sorted()
                case .failure(let error):
                    self.errorMessage = "Ошибка загрузки жанров: \(error.localizedDescription)"
                }
            }
        }
    }

    func loadMovies() {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        
        isSearching ? searchMovies(page: currentPage) : fetchMovies()
    }

    private func fetchMovies() {
        var query: [String: String] = [
            "page": "\(currentPage)",
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
            path: "/v1.4/movie",
            query: query,
            decodeTo: ServerResponse.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.appendMovies(response)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func searchMovies(page: Int) {
        APIManager.shared.request(
            path: "/v1.4/movie/search",
            query: [
                "query": searchText,
                "page": "\(page)"
            ],
            decodeTo: ServerResponse.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.appendMovies(response, page: page)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func refreshMovies() {
        currentPage = 1
        totalPages = 1
        movies.removeAll()
        loadMovies()
    }

    func clearSearch() {
        searchText = ""
        refreshMovies()
    }

    private func appendMovies(_ response: ServerResponse, page: Int? = nil) {
        if page ?? currentPage == 1 {
            movies = response.docs
        } else {
            movies.append(contentsOf: response.docs)
        }
        totalPages = response.pages ?? 1
        currentPage += 1
    }
}
