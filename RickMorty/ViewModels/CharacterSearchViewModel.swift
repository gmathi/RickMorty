//
//  CharacterSearchViewModel.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import Foundation
import Combine

@MainActor
class CharacterSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiClient: RMAPIClientProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    private static let defaultClient = RMAPIClient()
    
    init(apiClient: RMAPIClientProtocol? = nil) {
        self.apiClient = apiClient ?? Self.defaultClient
        setupSearchObserver()
    }
    
    private func setupSearchObserver() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    await self?.performSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    func performSearch() async {
        searchTask?.cancel()
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmedText.isEmpty else {
            characters = []
            isLoading = false
            errorMessage = nil
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        searchTask = Task {
            do {
                let results = try await apiClient.searchCharacters(name: trimmedText)
                if !Task.isCancelled {
                    characters = results
                    isLoading = false
                }
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
                    characters = []
                    isLoading = false
                }
            }
        }
    }
    
    func clearSearch() {
        searchTask?.cancel()
        searchText = ""
        characters = []
        isLoading = false
        errorMessage = nil
    }
}
