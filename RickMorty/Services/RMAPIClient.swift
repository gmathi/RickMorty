//
//  RMClient.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import Foundation

class RMAPIClient: RMAPIClientProtocol {
    private let baseURL = "https://rickandmortyapi.com/api/character/"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchCharacters(name: String) async throws -> [Character] {
        // Construct URL with proper encoding
        guard let url = constructURL(for: name) else {
            throw APIError.invalidURL
        }
        
        // Create request
        let request = URLRequest(url: url)
        
        // Perform async network call
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }
        
        // Validate response status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Handle 404 - no results found
        if httpResponse.statusCode == 404 {
            throw APIError.noResults
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        // Decode JSON to CharacterResponse
        do {
            let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return characterResponse.results
        } catch {
            // Check if it's the "nothing here" error response
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
               errorResponse["error"] != nil {
                throw APIError.noResults
            }
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func constructURL(for searchString: String) -> URL? {
        guard !searchString.isEmpty else {
            return nil
        }
        
        // Properly encode the search string for URL
        guard let encodedString = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        let urlString = "\(baseURL)?name=\(encodedString)"
        return URL(string: urlString)
    }
}
