//
//  ContentView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 04.03.2025.
//

import SwiftUI

struct MoviesView: View {
    @State private var movies: [MovieModel] = []
    @State private var currentPage = 0
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var path: [AppRoute] = []
    
    func loadMovies() {
        currentPage += 1
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        APIManager.shared.fetchMovies(page: currentPage) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedMovies):
                    self.movies.append(contentsOf: fetchedMovies)
                case .failure(let error):
                    self.errorMessage = "Ошибка \(error.localizedDescription)"
                }
            }
        }
    }
    
    func refreshMovies() {
        currentPage = 0
        movies.removeAll()
        loadMovies()
    }
 
    private func checkIfLastMovie(_ movie: MovieModel) {
        if movie == movies.last {
            loadMovies()
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                ScrollView {
                    LazyVStack{
                        ForEach(movies, id: \.id) { movie in
                            MovieItemView(movie: movie)
                                .tint(.black)
                                .onAppear {
                                    checkIfLastMovie(movie)
                                }
                        }
                        if isLoading {
                            ProgressView()
                        }
                    }
                }
                .refreshable {
                    refreshMovies()
                }
                .onAppear {
                    if movies.isEmpty {
                        loadMovies()
                    }
                }
                .navigationTitle("Фильмы")
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .movieDetail(let movie):
                        DetailView(movie: movie)
                    case .settings:
                        SettingsView()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: AppRoute.settings) {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}


/*   func generateMockData() {
 self.movies = [
 .init(
 id: 1,
 name: "El Atawla",
 alternativeName: nil,
 enName: nil,
 type: nil,
 typeNumber: nil,
 year: nil,
 description: "Овдовевшая мать, живущая под одной крышей со своей семьёй, незаметно вмешивается в жизни детей и их супругов. Манипулируя ими во имя своей всепоглощающей любви, она провоцирует столкновение между традициями и личными желаниями, что приводит к множеству напряжённых конфликтов.",
 shortDescription: nil,
 status: nil,
 rating: nil,
 votes: nil,
 movieLength: nil,
 totalSeriesLength: nil,
 seriesLength: nil,
 ratingMpaa: nil,
 ageRating: nil,
 poster: .init(url: "https://image.openmoviedb.com/kinopoisk-images/10893610/e10b13c7-6c31-4a7f-9efe-6c19c67dc5fc/x1000", previewUrl: "https://image.openmoviedb.com/kinopoisk-images/10893610/e10b13c7-6c31-4a7f-9efe-6c19c67dc5fc/orig"),
 backdrop: nil,
 genres: nil,
 countries: nil,
 releaseYears: nil,
 isSeries: nil,
 ticketsOnSale: nil),
 .init(
 id: 2,
 name: "Ashghal Shaqa",
 alternativeName: nil,
 enName: nil,
 type: nil,
 typeNumber: nil,
 year: nil,
 description: "Среди хаоса личных обид и корпоративных амбиций новый HR-менеджер Дмитрий стремится внедрить Кодекс с корпоративными ценностями успешной IT-компании. Желание обсудить здоровую корпоративную культуру неожиданно превращается в опасную игру — русскую рулетку.",
 shortDescription: nil,
 status: nil,
 rating: nil,
 votes: nil,
 movieLength: nil,
 totalSeriesLength: nil,
 seriesLength: nil,
 ratingMpaa: nil,
 ageRating: nil,
 poster: .init(url: "https://image.openmoviedb.com/kinopoisk-images/10812607/2e3e4997-70c3-4532-acc7-b51d3fc812b4/x1000", previewUrl: "https://image.openmoviedb.com/kinopoisk-images/10812607/2e3e4997-70c3-4532-acc7-b51d3fc812b4/x1000"),
 backdrop: nil,
 genres: nil,
 countries: nil,
 releaseYears: nil,
 isSeries: nil,
 ticketsOnSale: nil),
 .init(
 id: 3,
 name: "Bayt Hamoula",
 alternativeName: nil,
 enName: nil,
 type: nil,
 typeNumber: nil,
 year: nil,
 description: "Жизнерадостный призрак девушки Лили, чтобы упокоится, должна вывести из квартиры социофоба Никиту, который не покидает дом уже несколько лет.",
 shortDescription: nil,
 status: nil,
 rating: nil,
 votes: nil,
 movieLength: nil,
 totalSeriesLength: nil,
 seriesLength: nil,
 ratingMpaa: nil,
 ageRating: nil,
 poster: .init(url: "https://image.openmoviedb.com/kinopoisk-images/4716873/8c2fbb7d-6f37-438a-8d7f-6057ba10322a/x1000", previewUrl: "https://image.openmoviedb.com/kinopoisk-images/4716873/8c2fbb7d-6f37-438a-8d7f-6057ba10322a/x1000"),
 backdrop: nil,
 genres: nil,
 countries: nil,
 releaseYears: nil,
 isSeries: nil,
 ticketsOnSale: nil),
 ]
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
 */
#Preview {
    MoviesView()
}

