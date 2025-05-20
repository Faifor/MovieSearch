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
    
    func fetchMovies(page: Int, limit: Int = 10, sortField: String?, sortType: Int = 1, filter: String? = nil, completion: @escaping (Result<ServerResponse, Error>) -> Void) {
        var components = URLComponents(string: baseURL)!
        var queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "notNullFields", value: "poster.url")
        ]
        
        if let field = sortField {
            queryItems.append(URLQueryItem(name: "sortField", value: field))
            queryItems.append(URLQueryItem(name: "sortType", value: "\(sortType)"))
        }
        
        if let filter = filter {
            queryItems.append(URLQueryItem(name: "filter", value: filter))
        }

        components.queryItems = queryItems
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
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
    
    func fetchGenres(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: "https://api.kinopoisk.dev/v1/movie/possible-values-by-field?field=genres.name") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIManager.APIManagerError.noData))
                return
            }

            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON response from genres API: \(jsonString)")
                }

                struct GenreItem: Decodable {
                    let name: String
                    let slug: String
                }

                let decodedGenres = try JSONDecoder().decode([GenreItem].self, from: data)
                let genreNames = decodedGenres.map { $0.name }.sorted()

                DispatchQueue.main.async {
                    completion(.success(genreNames))
                }
            } catch {
                print("JSON decode error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON:\n\(jsonString)")
                }
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
