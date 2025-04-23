//
//  DetailViewViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 23.04.2025.
//

import SwiftUI

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
        
        APIManager.shared.fetchMovieDetail(movieId: movieId) { [self] result in
            isLoading = false
            switch result {
            case .success(let movieDetail):
                self.movieDetail = movieDetail
            case .failure(let error):
                self.errorMessage = "Ошибка: \(error.localizedDescription)"
            }
        }
    }
}
