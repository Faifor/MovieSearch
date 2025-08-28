//
//  DetailView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 10.03.2025.
//

import SwiftUI

struct DetailView: View {
    
    let movieId: Int
    @StateObject var viewModel: DetailViewViewModel
    
    init(movieId: Int) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: DetailViewViewModel(movieId: movieId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }

                Group {
                    if let posterURL = viewModel.movieDetail?.poster?.url,
                       let url = URL(string: posterURL) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                        }
                        .border(Color.gray, width: 5)
                    }
                }
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 45)

                HStack(alignment: .top) {
                    Text(viewModel.movieDetail?.name ?? "Без названия")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleLike()
                    }) {
                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isLiked ? .red : .gray)
                            .font(.system(size: 28))
                    }
                }
                .padding([.leading, .trailing], 16)
                
                Divider()

                Text("Год выпуска: \(String(viewModel.movieDetail?.year ?? 0))")
                    .font(.subheadline)
                    .padding([.leading, .trailing], 16)

                Divider()

                Text("Рейтинг: \(String(format: "%.1f", viewModel.movieDetail?.rating?.imdb ?? 0.0))")
                    .font(.subheadline)
                    .padding([.leading, .trailing], 16)

                Divider()

                Text(viewModel.movieDetail?.description ?? "Описания нет")
                    .padding([.leading, .trailing], 16)
            }
        }
        .navigationTitle(viewModel.movieDetail?.name ?? "Фильм")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.movieDetail == nil {
                Task {
                    await viewModel.fetchMovieDetails()
                }
            }
        }
    }
}




