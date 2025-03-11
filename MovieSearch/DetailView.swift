//
//  DetailView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 10.03.2025.
//

import SwiftUI

struct DetailView: View {
    
    var movie: Docs
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let posterURL = movie.poster.previewUrl, let url = URL(string: posterURL) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 250)
                }
                Text(movie.name)
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                if let year = movie.year {
                    Text("Год выпуска: \(year)")
                        .font(.subheadline)
                        .padding(.top, 2)
                }
                
                if let rating = movie.rating.kp {
                    Text("Рейтинг: \(rating, specifier: "%.1f") (КП)")
                        .font(.subheadline)
                        .padding(.top, 2)
                }
                
                if let description = movie.description {
                    Text(description)
                        .padding(.top)
                        .padding([.leading, .trailing], 16)
                } else {
                    Text("Описание отсутствует")
                        .padding(.top)
                        .padding([.leading, .trailing], 16)
                }
                
                VStack(alignment: .leading) {
                    if !movie.premiere.world.isEmpty {
                        Text("Премьера: \(movie.premiere.world)")
                            .font(.subheadline)
                            .padding(.top, 10)
                    }
                }
                
                if !movie.similarMovies.isEmpty {
                    Text("Похожие фильмы:")
                        .font(.headline)
                        .padding(.top, 20)
                
                    ForEach(movie.similarMovies) { similarMovie in
                        VStack(alignment: .leading) {
                            if let similarPosterURL = similarMovie.poster.url, let url = URL(string: similarPosterURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: 50, height: 75)
                            }
                            Text(similarMovie.name)
                                .font(.subheadline)
                                .padding(.top, 5)
                        }
                        .padding([.leading, .trailing], 16)
                    }
                }
            }
        }
        .navigationTitle(movie.name)
    }
}

