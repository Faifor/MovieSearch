//
//  MoviesViewViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 16.04.2025.
//
import Foundation
import Combine

@MainActor
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
    
    private let service: MovieServiceProtocol = MovieService()
    
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
                    Task {
                        await refreshMovies()
                    }
                }
            }
        }
    
    @Published var searchText: String = ""
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    func refreshMovies() async {
        currentPage = 1
        totalPages = 1
        movies.removeAll()
        await loadMovies()
    }
    
    func clearSearch() async {
        searchText = ""
        await refreshMovies()
    }
    
    func loadGenres() {
        Task {
            do {
                self.genres = try await service.fetchGenres()
            } catch {
                self.errorMessage = "Ошибка загрузки жанров: \(error.localizedDescription)"
            }
        }
    }
    
    @MainActor
    func loadMovies() async {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        
        await isSearching ? searchMovies(page: currentPage) : fetchMovies()
    }
    
    @MainActor
    private func fetchMovies() async {
        isLoading = true
        do {
            let response = try await service.fetchMovies(
                page: currentPage,
                sortOrder: sortOrder,
                selectedGenres: selectedGenres
            )
            appendMovies(response)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    private func searchMovies(page: Int) async {
        do {
            let response = try await service.searchMovies(query: searchText, page: page)
            isLoading = false
            appendMovies(response, page: page)
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
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
