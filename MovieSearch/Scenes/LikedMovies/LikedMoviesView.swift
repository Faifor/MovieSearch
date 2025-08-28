//
//  LikedMoviesView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 27.05.2025.
//

import SwiftUI

struct LikedMoviesView: View {
    @StateObject private var viewModel = LikedMoviesViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.likedMovies, id: \.id) { movie in
                        NavigationLink(destination: DetailView(movieId: movie.id)) {
                            MovieDetailRow(movie: movie)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Избранное")
            .onAppear {
                viewModel.loadLikedMovies()
            }
        }
    }
}
