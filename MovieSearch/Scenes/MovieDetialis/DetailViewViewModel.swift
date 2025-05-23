//
//  DetailViewViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 23.04.2025.
//

import Foundation

class DetailViewViewModel: ObservableObject {
    
    let movieId: Int

    @Published var movieDetail: MovieDetailModel?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init(movieId: Int) {
        self.movieId = movieId
        fetchMovieDetails()
    }
    
    func fetchMovieDetails() {
        isLoading = true
        errorMessage = nil

        APIManager.shared.request(
            path: "/v1.4/movie/\(movieId)",
            decodeTo: MovieDetailModel.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    self?.movieDetail = detail
                case .failure(let error):
                    self?.errorMessage = "Ошибка: \(error.localizedDescription)"
                }
            }
        }
    }
}
