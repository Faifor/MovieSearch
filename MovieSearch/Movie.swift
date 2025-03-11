//
//  Movie.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 04.03.2025.
//

import Foundation

struct MovieResponse: Codable {
    let movies: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let rating: Double?
    let year: Int?
    let posterURL: String?
}



