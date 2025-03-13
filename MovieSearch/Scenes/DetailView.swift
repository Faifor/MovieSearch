//
//  DetailView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 10.03.2025.
//

import SwiftUI

struct DetailView: View {
    let movie: MovieModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    if let posterURL = movie.poster?.previewUrl, let url = URL(string: posterURL) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(height: 250)
                    }
                }
                .padding(.bottom)
                
                
                Spacer().frame(height: 165)
                
                Text(movie.name ?? "Без названия")
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .padding([.leading, .trailing], 16)

                Divider()
                
                Text("Год выпуска: \(movie.year ?? 0)")
                        .font(.subheadline)
                        .padding(.top, 2)
                        .padding([.leading, .trailing], 16)
                
                Divider()
                
                Text("Рейтинг: \(movie.rating?.imdb ?? 0.0)")
                    .font(.subheadline)
                    .padding(.top, 2)
                    .padding([.leading, .trailing], 16)
                
                Divider()
                
                
            Text(movie.description ?? "Описания нет")
                        .padding(.top, 2)
                        .padding([.leading, .trailing], 16)
            }
        }
        .navigationTitle(movie.name ?? "Без названия")
    }
}



/*#Preview {
    // Создайте объект `movie` для тестирования, если хотите увидеть отображение
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


