//
//  ConfigManager.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 24.05.2025.
//

import Foundation

enum ConfigManager {
    private static var config: [String: Any]? {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let dict = plist as? [String: Any] else {
            return nil
        }
        return dict
    }

    static var apiKey: String {
        guard let key = config?["API_KEY"] as? String else {
            fatalError("API_KEY not found in Config.plist")
        }
        return key
    }

    static var baseURL: URL {
        guard let urlString = config?["BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("BASE_URL not found or invalid in Config.plist")
        }
        return url
    }
}
