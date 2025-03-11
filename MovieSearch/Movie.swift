//
//  Movie.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 04.03.2025.
//

import Foundation

struct ServerResponse: Codable {
    let docs: [Movie]
    let total: Int
    let limit: Int
    let page: Int
    let pages: Int
}

struct Movie: Codable, Identifiable {
    let id: Int
    let name: String?
    let alternativeName: String?
    let enName: String?
    let type: String
    let typeNumber: Int
    let year: Int?
    let description: String?
    let shortDescription: String?
    let status: String?
    let rating: Rating
    let votes: Votes
    let movieLength: Int?
    let totalSeriesLength: Int?
    let seriesLength: Int?
    let ratingMpaa: String?
    let ageRating: Int?
    let poster: Poster?
    let backdrop: Backdrop?
    let genres: [Genre]
    let countries: [Country]
    let releaseYears: [ReleaseYear]
    let isSeries: Bool
    let ticketsOnSale: Bool
}

struct Rating: Codable {
    let kp: Double
    let imdb: Double
    let filmCritics: Double
    let russianFilmCritics: Double
    let await: Double
}

struct Votes: Codable {
    let kp: Int
    let imdb: Int
    let filmCritics: Int
    let russianFilmCritics: Int
    let await: Int
}

struct Poster: Codable {
    let url: String
    let previewUrl: String
}

struct Backdrop: Codable {
    let url: String
    let previewUrl: String
}

struct Genre: Codable {
    let name: String
}

struct Country: Codable {
    let name: String
}

struct ReleaseYear: Codable {
    let start: Int?
    let end: Int?
}


