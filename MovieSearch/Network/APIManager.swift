//
//  APIManager.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 05.03.2025.
//

import Foundation

struct APIManager {
    
    enum APIManagerError: Error {
        case noData
    }
    
    static let shared = APIManager()
    private let apiKey = "CVQC8JP-KXZ46FD-G0Q391R-7R5VPPZ"
    private let baseURL = "https://api.kinopoisk.dev/v1.4/movie"
    
    func fetchMovies(page: Int, completion: @escaping (Result<ServerResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?page=\(page)&notNullFields=poster.url") else { return }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                print("Нет данных")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print("\(json)")
                let decodedResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("Ошибка декодирования: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailModel, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(movieId)") else { return }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        print(request)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decodedMovie = try JSONDecoder().decode(MovieDetailModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedMovie))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<ServerResponse, Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search?query=\(encodedQuery)&page=\(page)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(APIManagerError.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
