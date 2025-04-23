//
//  DetailView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 10.03.2025.
//

import SwiftUI

struct DetailView: View {
    
    let movieId: Int
    @StateObject var detailView: DetailViewViewModel
    
    init(movieId: Int) {
        self.movieId = movieId
        _detailView = StateObject(wrappedValue: DetailViewViewModel(movieId: movieId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let errorMessage = detailView.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if detailView.isLoading {
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                Group {
                    if let posterURL = detailView.movieDetail?.poster?.url, let url = URL(string: posterURL) {
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
                
                Text(detailView.movieDetail?.name ?? "Без названия")
                    .font(.title)
                    .bold()
                    .padding([.leading, .trailing], 16)
                
                Divider()
                
                Text("Год выпуска: \(detailView.movieDetail?.year ?? 0)")
                    .font(.subheadline)
                    .padding([.leading, .trailing], 16)
                
                Divider()
                
                Text("Рейтинг: \(String(format: "%.1f", detailView.movieDetail?.rating?.imdb ?? 0.0))")
                    .font(.subheadline)
                    .padding([.leading, .trailing], 16)
                
                Divider()
                
                Text(detailView.movieDetail?.description ?? "Описания нет")
                    .padding([.leading, .trailing], 16)
                
            }
        }
        .navigationTitle(detailView.movieDetail?.name ?? "Фильм")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if detailView.movieDetail == nil {
                detailView.fetchMovieDetails()
            }
        }
    }
}





