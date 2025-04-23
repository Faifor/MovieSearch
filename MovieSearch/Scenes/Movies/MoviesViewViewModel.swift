//
//  MoviesViewViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 16.04.2025.
//
import Foundation

class MoviesViewViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    @Published var searchText: String = ""
    @Published var currentPage = 1
    @Published var totalPages = 1
    @Published var searchPage = 1
    @Published var searchTotalPages = 1
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    func searchMovies(page: Int = 1) {
        
        guard !searchText.isEmpty, !isLoading, page <= searchTotalPages else { return }
        
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
                    self.searchTotalPages = response.pages ?? 1
                    self.searchPage = page + 1
                case .failure:
                    if page == 1 {
                        self.movies = []
                    }
                }
            }
        }
    }
    
    func loadMovies() {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        
        APIManager.shared.fetchMovies(page: currentPage) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.docs.isEmpty { return }
                    self.movies.append(contentsOf: response.docs)
                    self.totalPages = response.pages ?? 1
                    self.currentPage += 1
                case .failure:
                    return
                }
            }
        }
    }
    
    func refreshMovies() {
        if isSearching {
            searchPage = 1
            searchTotalPages = 1
            searchMovies(page: 1)
        } else {
            searchText = ""
            searchPage = 1
            searchTotalPages = 1
            currentPage = 1
            totalPages = 1
            movies.removeAll()
            loadMovies()
        }
        
    }
    
    func loadMoreIfNeeded(_ movie: MovieModel) {
        if let lastMovie = movies.last, movie.id == lastMovie.id {
            if isSearching {
                searchMovies(page: searchPage)
            } else {
                loadMovies()
            }
        }
    }
}
