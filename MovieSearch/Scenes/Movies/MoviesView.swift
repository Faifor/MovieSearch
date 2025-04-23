//
//  ContentView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 04.03.2025.
//

import SwiftUI

struct MoviesView: View {
    
    @StateObject var viewModel: MoviesViewViewModel
    @State private var path: [AppRoute] = []
    
    
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                SearchBar(
                    searchText: $viewModel.searchText,
                    onSearch: {
                        viewModel.searchMovies(page: 1)
                    },
                    onClear: {
                        viewModel.refreshMovies()
                    }
                )
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            MovieRow(movie: movie, onAppear: {
                                viewModel.loadMoreIfNeeded(movie)
                            })
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                        }
                        if viewModel.currentPage > viewModel.totalPages && !viewModel.isSearching {
                            Text("Больше нет")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                }
                .refreshable {
                    viewModel.refreshMovies()
                    
                }
                .onAppear {
                    if viewModel.movies.isEmpty {
                        viewModel.loadMovies()
                    }
                }
                .navigationTitle("Фильмы")
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .movieDetail(let movieId):
                        DetailView(movieId: movieId)
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

struct MovieRow: View {
    let movie: MovieModel
    let onAppear: () -> Void
    
    var body: some View {
        NavigationLink(value: AppRoute.movieDetail(movieId: movie.id)) {
            MovieItemView(movie: movie)
                .tint(.black)
                .onAppear {
                    onAppear()
                }
        }
    }
}

#Preview(body: {
    MoviesView(viewModel: .init())
})
