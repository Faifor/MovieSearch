//
//  MovieItemView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 17.03.2025.
//

import SwiftUI

struct MovieItemView: View {
    let movie: MovieModel
    var body: some View {
        NavigationLink(value: AppRoute.movieDetail(movieId: movie.id)) {
            HStack {
                Group {
                    if let urlString = movie.poster?.url, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                            
                        } placeholder: {
                            ProgressView()
                        }
                        
                    } else {
                        Image(systemName: "photo")
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 150)
                            .clipped()
                            .border(Color.white, width: 5)
                    }
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 150)
                .clipped()
                .border(Color.white, width: 5)
                
                VStack(alignment: .leading) {
                    Text(movie.name ?? "Без названия").font(.title2)
                        .lineLimit(1)
                    Text(movie.description ?? "")
                        .font(.subheadline)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding()
                Spacer()
                VStack{
                    Text("Рейтинг \n \(String(format: "%.1f", movie.rating?.imdb ?? 0.0))")
                    Spacer()
                }
                .padding()
            }
            .border(Color.gray, width: 5)
            .cornerRadius(10)
        }
    }
}
