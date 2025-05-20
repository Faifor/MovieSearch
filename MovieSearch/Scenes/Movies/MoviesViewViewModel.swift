//
//  MoviesViewViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 16.04.2025.
//
import Foundation

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
            case .none: return "id" 
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
        didSet {
            if !isSearching {
                refreshMovies()
            }
        }
    }

    @Published var searchText: String = ""
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func loadGenres() {
        print("Начинаю загрузку жанров...")
        APIManager.shared.fetchGenres { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loadedGenres):
                    print("Жанры загружены: \(loadedGenres)")
                    self.genres = loadedGenres.sorted()
                case .failure(let error):
                    print("Ошибка загрузки жанров: \(error.localizedDescription)")
                    self.genres = []
                }
            }
        }
    }

    func loadMovies() {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true

        if isSearching {
            searchMovies(page: currentPage)
            return
        }
        
        var filter: String? = nil
        if !selectedGenres.isEmpty {
            let genresArray = Array(selectedGenres)
            if let jsonData = try? JSONSerialization.data(withJSONObject: ["genres.name": ["$in": genresArray]], options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                filter = jsonString
            }
        }

        APIManager.shared.fetchMovies(
            page: currentPage,
            limit: 10,
            sortField: sortOrder.apiSortField,
            sortType: sortOrder.apiSortType,
            filter: filter
        ) { result in
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

    func refreshMovies() {
        currentPage = 1
        totalPages = 1
        movies.removeAll()
        loadMovies()
    }

    func searchMovies(page: Int = 1) {
        guard !searchText.isEmpty else { return }

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
                    self.currentPage += 1
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func clearSearch() {
        searchText = ""
        refreshMovies()
    }
}
