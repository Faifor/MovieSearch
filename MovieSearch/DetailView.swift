//
//  DetailView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 10.03.2025.
//

import SwiftUI

struct DetailView: View {
    
    var movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let urlString = movie.posterURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "photo")
                    }
                }
                Text(movie.name).font(.title)
                Text("Год \(movie.year ?? 0)")
                Text("Рейтинг \(movie.rating ?? 0)")
                Text(movie.description ?? "Нет описания")
                    .padding()
            }
        }
        .navigationTitle(movie.name)
    }
}


