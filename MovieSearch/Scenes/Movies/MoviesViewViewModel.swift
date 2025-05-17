//
//  MoviesViewViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 16.04.2025.
//
import Foundation

class MoviesViewViewModel: ObservableObject {
    
    enum SortOrder: String, CaseIterable, Identifiable {
        case nameAsc = "name_asc"
        case nameDesc = "name_desc"
        case ratingAsc = "rating.kp_asc"
        case ratingDesc = "rating.kp_desc"
        
        var id: String { rawValue }
        
        var apiSortField: String {
            switch self {
            case .nameAsc, .nameDesc: return "name"
            case .ratingAsc, .ratingDesc: return "rating.kp"
            }
        }
        
        var apiSortType: Int {
            switch self {
            case .nameAsc, .ratingAsc: return 1
            case .nameDesc, .ratingDesc: return -1
            }
        }
        
        var description: String {
            switch self {
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
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    
    @Published var sortOrder: SortOrder = .nameAsc {
        didSet {
            refreshMovies()
        }
    }
    
    func loadMovies() {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        
        APIManager.shared.fetchMovies(page: currentPage, limit: 10, sortField: sortOrder.apiSortField, sortType: sortOrder.apiSortType) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if self.currentPage == 1 {
                        self.movies = response.docs
                    } else {
                        self.movies.append(contentsOf: response.docs)
                    }
                    self.totalPages = response.pages ?? 1
                    self.currentPage += 1
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func handleSearch() {
        isSearching = !searchText.isEmpty
        currentPage = 1
        totalPages = 1
        movies.removeAll()
        if isSearching {
            searchMovies()
        } else {
            loadMovies()
        }
    }

    func searchMovies(page: Int = 1) {
        guard !isLoading, !searchText.isEmpty, page <= totalPages else { return }
        isLoading = true

        APIManager.shared.searchMovies(query: searchText, page: page) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if page == 1 {
                        self.movies = response.docs
                    } else {
                        self.movies.append(contentsOf: response.docs)
                    }
                    self.totalPages = response.pages ?? 1
                    self.currentPage = page + 1
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func refreshMovies() {
        currentPage = 1
        totalPages = 1
        movies.removeAll()
        if isSearching {
            searchMovies(page: 1)
        } else {
            loadMovies()
        }
    }
}
