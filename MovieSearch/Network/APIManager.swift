//
//  APIManager.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 05.03.2025.
//


import Foundation

final class APIManager {
    
    static let shared = APIManager()
    
    private let apiKey = ConfigManager.apiKey
    private let baseURL = ConfigManager.baseURL
    
    enum APIError: Error {
        case invalidURL
        case noData
        case decodingError(Error)
        case httpError(Int)
    }
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        method: String = "GET",
        query: [String: String]? = nil,
        decodeTo type: T.Type
    ) async throws -> T {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }

        if let query = query {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
