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
    }
    
    @MainActor
    func fetchMovieDetails() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let detail = try await service.fetchMovieDetail(id: movieId)
            movieDetail = detail
            isLiked = likedService.isLiked(id: detail.id)
        } catch {
            errorMessage = "Ошибка: \(error.localizedDescription)"
        }
        isLoading = false
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
