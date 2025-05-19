//
//  ContentView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 04.03.2025.
//

import SwiftUI

struct MoviesView: View {

    @StateObject var viewModel = MoviesViewViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Поиск...", text: $viewModel.searchText, onCommit: {
                        viewModel.refreshMovies()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                    if viewModel.isSearching {
                        Button(action: {
                            viewModel.clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing)
                    }
                }

                if !viewModel.isSearching {
                    Menu {
                        ForEach(MoviesViewViewModel.SortOrder.allCases) { option in
                            Button(option.description) {
                                viewModel.sortOrder = option
                            }
                        }
                    } label: {
                        Label("Сортировка", systemImage: "arrow.up.arrow.down")
                            .font(.headline)
                            .padding(.bottom, 8)
                    }
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            NavigationLink(destination: DetailView(movieId: movie.id)) {
                                MovieRow(movie: movie)
                                    .onAppear {
                                        if movie == viewModel.movies.last {
                                            viewModel.loadMovies()
                                        }
                                    }
                            }
                        }

                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.top, 8)
                }
                .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
                .refreshable {
                    viewModel.refreshMovies()
                }
                .onAppear {
                    if viewModel.movies.isEmpty {
                        viewModel.loadMovies()
                    }
                }
                .navigationTitle("Фильмы")
            }
        }
    }
}

struct MovieRow: View {
    let movie: MovieModel
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: movie.poster?.url ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.name ?? "Без названия")
                    .font(.headline)
                    .lineLimit(2)
                
                if let rating = movie.rating?.kp {
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

#Preview(body: {
    MoviesView(viewModel: .init())
})
