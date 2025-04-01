//
//  DetailView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 10.03.2025.
//

import SwiftUI

struct DetailView: View {
    let movieId: Int
    
    @State private var movieDetail: MovieDetailModel?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    func fetchMovieDetails() {
        isLoading = true
        errorMessage = nil
        
        APIManager.shared.fetchMovieDetail(movieId: movieId) { result in
            isLoading = false
            switch result {
            case .success(let movieDetail):
                self.movieDetail = movieDetail
            case .failure(let error):
                self.errorMessage = "Ошибка: \(error.localizedDescription)"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if isLoading {
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                Group {
                    if let posterURL = movieDetail?.poster?.url, let url = URL(string: posterURL) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                        }
                        .border(Color.gray, width: 5)
                    }
                }
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 45)
                
                Text(movieDetail?.name ?? "Без названия")
                    .font(.title)
                    .bold()
                    .padding([.leading, .trailing], 16)
                
                Divider()
                
                Text("Год выпуска: \(movieDetail?.year ?? 0)")
                    .font(.subheadline)
                    .padding([.leading, .trailing], 16)
                
                Divider()
                
                Text("Рейтинг: \(String(format: "%.1f", movieDetail?.rating?.imdb ?? 0.0))")
                    .font(.subheadline)
                    .padding([.leading, .trailing], 16)
                
                Divider()
                
                Text(movieDetail?.description ?? "Описания нет")
                    .padding([.leading, .trailing], 16)
                
            }
        }
        .navigationTitle(movieDetail?.name ?? "Фильм")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if movieDetail == nil {
                fetchMovieDetails()
            }
        }
    }
}


/*
 #Preview {
 DetailView(movie: MovieModel(
 id: 1,
 name: "El Atawla",
 alternativeName: nil,
 enName: nil,
 type: nil,
 typeNumber: nil,
 year: 2013,
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
 ticketsOnSale: nil))
 }
 */


