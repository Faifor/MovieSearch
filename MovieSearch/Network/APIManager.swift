//
//  APIManager.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 05.03.2025.
//

import Foundation

import Foundation

final class APIManager {
    
    static let shared = APIManager()
    
    private let apiKey = "HD9DV2N-Z9ZMGGC-K6E71TS-4FXABNS"
    private let baseURL = URL(string: "https://api.kinopoisk.dev")!
    
    enum APIError: Error {
        case invalidURL
        case noData
        case decodingError(Error)
        case httpError(Int)
    }
    
    func request<T: Decodable>(
        path: String,
        method: String = "GET",
        query: [String: String]? = nil,
        decodeTo type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            return completion(.failure(APIError.invalidURL))
        }
        
        if let query = query {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else {
            return completion(.failure(APIError.invalidURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                return completion(.failure(error))
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(APIError.httpError(httpResponse.statusCode)))
            }
            
            guard let data = data else {
                return completion(.failure(APIError.noData))
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                completion(.failure(APIError.decodingError(error)))
            }
        }.resume()
    }
}
