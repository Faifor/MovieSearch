//
//  Untitled.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 18.03.2025.
//

import Foundation

struct MovieDetailModel: Codable {
    let id: Int
    let name: String?
    let alternativeName: String?
    let year: Int?
    let description: String?
    let rating: RatingDetail?
    let poster: ImageURL?
    let genres: [GenreDetail]?
}

struct RatingDetail: Codable {
    let imdb: Double?
}

struct ImageURL: Codable {
    let url: String?
    let posterURL: String?
}

struct GenreDetail: Codable {
    let name: String?

}
