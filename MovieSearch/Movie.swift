//
//  Movie.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 04.03.2025.
//

import Foundation

struct MovieResponse: Codable {
    let docs: [Docs]
}

struct Docs: Codable, Identifiable {
    let id: Int
    let externalId: ExternalId
    let name: String
    let alternativeName: String?
    let enName: String?
    let year: Int?
    let description: String?
    let rating: Rating
    let poster: Poster
    let genres: [Genre]
    let countries: [Country]
    let persons: [Person]
    let reviewInfo: ReviewInfo
    let premiere: Premiere
    let similarMovies: [SimilarMovie]
    let status: String?
    let movieLength: Int?
    let logo: Logo?
}

struct ExternalId: Codable {
    let kpHD: String?
    let imdb: String?
    let tmdb: Int?
}

struct Rating: Codable {
    let kp: Double?
    let imdb: Double?
    let tmdb: Double?
    let filmCritics: Double?
    let russianFilmCritics: Double?
    let await: Double?
}

struct Poster: Codable {
    let url: String?
    let previewUrl: String?
}

struct Genre: Codable {
    let name: String
}

struct Country: Codable {
    let name: String
}

struct Person: Codable {
    let id: Int
    let photo: String?
    let name: String
    let enName: String?
    let description: String?
    let profession: String?
    let enProfession: String?
}

struct ReviewInfo: Codable {
    let count: Int
    let positiveCount: Int
    let percentage: String
}

struct Premiere: Codable {
    let country: String
    let world: String
    let russia: String
    let digital: String?
    let cinema: String
    let bluray: String?
    let dvd: String?
}

struct SimilarMovie: Codable, Identifiable {
    let id: Int
    let name: String
    let enName: String?
    let alternativeName: String?
    let year: Int
    let poster: Poster
    let rating: Rating
}

struct Logo: Codable {
    let url: String?
}


