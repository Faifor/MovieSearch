//
//  ContentView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 04.03.2025.
//

import SwiftUI

struct MovieView: View {
    @State private var movies: [Movie] = []
    @State private var currentPage = 1

    var body: some View {
        NavigationView {
            List(movies) { movie in
                NavigationLink(destination: DetailView(movie: movie)) {
                    HStack {
                        if let urlString = movie.poster?.url, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 75)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(movie.name ?? "Без названия").font(.headline)
                            Text("Рейтинг: \(movie.rating.kp)")
                        }
                    }
                }
            }
            .onAppear {
                fetchMovies()
            }
            .navigationTitle("Фильмы")
        }
    }
    
    func fetchMovies() {
        APIManager.shared.fetchMovies(page: currentPage) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                    print("Загружено \(movies.count) фильмов")
                case .failure(let error):
                    print("Ошибка загрузки фильмов: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    MovieView()
}
