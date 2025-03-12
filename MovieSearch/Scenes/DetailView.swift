//
//  DetailView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 10.03.2025.
//

import SwiftUI

struct DetailView: View {
    var movie: MovieModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let posterURL = movie.poster?.previewUrl, let url = URL(string: posterURL) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 250)
                }
                Text(movie.name ?? "Без названия")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                if let year = movie.year {
                    Text("Год выпуска: \(year)")
                        .font(.subheadline)
                        .padding(.top, 2)
                }
                
                Text("Рейтинг: \(movie.rating?.kp ?? 0.0, specifier: "%.1f") (КП)")
                    .font(.subheadline)
                    .padding(.top, 2)
                
                if let description = movie.description {
                    Text(description)
                        .padding(.top)
                        .padding([.leading, .trailing], 16)
                } else {
                    Text("Описание отсутствует")
                        .padding(.top)
                        .padding([.leading, .trailing], 16)
                }
            }
        }
        .navigationTitle(movie.name ?? "Без названия")
    }
}


