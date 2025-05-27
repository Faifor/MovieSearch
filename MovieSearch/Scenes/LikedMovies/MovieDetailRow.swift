//
//  MovieDetailRow.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 27.05.2025.
//

import SwiftUI

struct MovieDetailRow: View {
    let movie: MovieDetailModel

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: movie.poster?.url ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.name ?? "Без названия")
                    .font(.headline)
                    .lineLimit(1)
                if let rating = movie.rating?.imdb {
                    Text("Рейтинг: \(String(format: "%.1f", rating))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
