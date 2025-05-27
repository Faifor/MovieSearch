//
//  ContentView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 04.03.2025.
//

import SwiftUI

struct MoviesView: View {
    
    @StateObject var viewModel = MoviesViewViewModel()
    @State private var showGenrePopover = false
    
    let columns = [GridItem(.adaptive(minimum: 80), spacing: 10)]
    
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                if !viewModel.isSearching {
                    sortAndGenreControls
                }
                movieList
            }
            .navigationTitle("Фильмы")
            .toolbar {
                NavigationLink(destination: LikedMoviesView()) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            
        }
    }
    
    private var searchBar: some View {
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
    }
    
    private var sortAndGenreControls: some View {
        HStack(spacing: 20) {
            Menu {
                ForEach(MoviesViewViewModel.SortOrder.allCases) { option in
                    Button(option.description) {
                        viewModel.sortOrder = option
                    }
                }
            } label: {
                Label("Сортировка", systemImage: "arrow.up.arrow.down")
                    .font(.headline)
            }
            
            Button {
                showGenrePopover.toggle()
            } label: {
                Label("Жанры (\(viewModel.selectedGenres.count))", systemImage: "tag")
                    .font(.headline)
            }
            .popover(isPresented: $showGenrePopover) {
                genrePopover
            }
        }
        .padding(.bottom, 8)
    }
    
    private var genrePopover: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Выберите жанры")
                .font(.title3.bold())
                .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.genres, id: \.self) { genre in
                        genreTag(genre)
                    }
                }
                .padding(.horizontal)
            }
            
            Divider()
            
            HStack {
                Button(action: {
                    viewModel.selectedGenres.removeAll()
                    viewModel.isGenreSelectionDirty = true
                }) {
                    Label("Сбросить", systemImage: "arrow.uturn.left")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.refreshMovies()
                    viewModel.isGenreSelectionDirty = false
                    showGenrePopover = false
                }) {
                    Label("Применить", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(viewModel.isGenreSelectionDirty ? Color.accentColor : Color.gray.opacity(0.5))
                        .cornerRadius(12)
                }
                .disabled(!viewModel.isGenreSelectionDirty)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
        .frame(width: 320, height: 450)
    }
    
    private func genreTag(_ genre: String) -> some View {
        Text(genre)
            .font(.subheadline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                viewModel.selectedGenres.contains(genre)
                ? Color.accentColor.opacity(0.8)
                : Color(.systemGray6)
            )
            .foregroundColor(
                viewModel.selectedGenres.contains(genre)
                ? .white
                : .primary
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(viewModel.selectedGenres.contains(genre) ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if viewModel.selectedGenres.contains(genre) {
                        viewModel.selectedGenres.remove(genre)
                    } else {
                        viewModel.selectedGenres.insert(genre)
                    }
                    viewModel.isGenreSelectionDirty = true
                }
            }
    }
    
    private var movieList: some View {
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
                viewModel.loadGenres()
                viewModel.loadMovies()
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
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                
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
