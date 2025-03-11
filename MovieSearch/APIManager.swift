//
//  APIManager.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 05.03.2025.
//

import Foundation

struct APIManager {
    static let shared = APIManager()
    private let apiKey = "CVQC8JP-KXZ46FD-G0Q391R-7R5VPPZ"
    private let baseURL = "https://api.kinopoisk.dev/v1.4/movie"
    
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?page=\(page)") else { return }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
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
                let decodedResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.docs))
                }
            } catch {
                print("Ошибка декодирования: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
