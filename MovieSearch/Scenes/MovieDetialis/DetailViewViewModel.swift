//
//  DetailViewViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 23.04.2025.
//

import Foundation
import Combine

class DetailViewViewModel: ObservableObject {
    let movieId: Int
    
    @Published var movieDetail: MovieDetailModel?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isLiked = false
    
    private let service: MovieServiceProtocol = MovieService()
    private let likedService = LikedMoviesService.shared
    
    init(movieId: Int) {
        self.movieId = movieId
        self.isLiked = likedService.isLiked(id: movieId)
        fetchMovieDetails()
    }
    
    func fetchMovieDetails() {
        isLoading = true
        errorMessage = nil
        
        service.fetchMovieDetail(id: movieId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    self?.movieDetail = detail
                    // обновить статус лайка (на случай если загрузка пришла позже)
                    self?.isLiked = self?.likedService.isLiked(id: detail.id) ?? false
                case .failure(let error):
                    self?.errorMessage = "Ошибка: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func toggleLike() {
        if isLiked {
            likedService.unlike(movieId: movieId)
        } else if let detail = movieDetail {
            likedService.like(movie: detail)
        }
        isLiked.toggle()
    }
}
