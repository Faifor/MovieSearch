//
//  LikedMoviesService.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 27.05.2025.
//

import Foundation

class LikedMoviesService {
    static let shared = LikedMoviesService()

    private let storageKey = "liked_movies"
    private var likedMovies: [Int: MovieDetailModel] = [:]

    private init() {
        loadFromStorage()
    }

    func like(movie: MovieDetailModel) {
        likedMovies[movie.id] = movie
        saveToStorage()
    }

    func unlike(movieId: Int) {
        likedMovies.removeValue(forKey: movieId)
        saveToStorage()
    }

    func isLiked(id: Int) -> Bool {
        likedMovies[id] != nil
    }

    func getAllLikedMovies() -> [MovieDetailModel] {
        Array(likedMovies.values)
    }

    private func saveToStorage() {
        do {
            let data = try JSONEncoder().encode(Array(likedMovies.values))
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Ошибка при сохранении лайкнутых фильмов: \(error)")
        }
    }

    private func loadFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let movies = try JSONDecoder().decode([MovieDetailModel].self, from: data)
            likedMovies = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
        } catch {
            print("Ошибка при загрузке лайкнутых фильмов: \(error)")
        }
    }
}

