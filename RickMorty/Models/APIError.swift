//
//  APIError.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case noResults
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid search URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .noResults:
            return "No characters found"
        }
    }
}
