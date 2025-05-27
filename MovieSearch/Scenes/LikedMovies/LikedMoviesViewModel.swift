//
//  LikedMoviesViewModel.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 27.05.2025.
//

import Foundation

class LikedMoviesViewModel: ObservableObject {
    @Published var likedMovies: [MovieDetailModel] = []
    
    private let likedService = LikedMoviesService.shared
    
    func loadLikedMovies() {
        likedMovies = likedService.getAllLikedMovies()
    }
}
