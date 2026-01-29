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
    @Published var selectedStatus: String? = nil
    @Published var selectedSpecies: String? = nil
    @Published var selectedType: String? = nil
    
    // Dynamic filter options based on search results
    @Published var availableStatuses: [String] = []
    @Published var availableSpecies: [String] = []
    @Published var availableTypes: [String] = []
    
    // Store unfiltered results - exposed for filter visibility check
    var allCharacters: [Character] = []
    
    private let apiClient: RMAPIClientProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    private static let defaultClient = RMAPIClient()
    
    init(apiClient: RMAPIClientProtocol? = nil) {
        self.apiClient = apiClient ?? Self.defaultClient
        setupSearchObserver()
    }
    
    private func setupSearchObserver() {
        // Observe search text changes
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    await self?.performSearch()
                }
            }
            .store(in: &cancellables)
        
        // Observe filter changes - apply filters without re-fetching
        Publishers.CombineLatest3($selectedStatus, $selectedSpecies, $selectedType)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _, _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func performSearch() async {
        searchTask?.cancel()
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmedText.isEmpty else {
            allCharacters = []
            characters = []
            availableStatuses = []
            availableSpecies = []
            availableTypes = []
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
                    allCharacters = results
                    updateAvailableFilters()
                    applyFilters()
                    isLoading = false
                }
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
                    allCharacters = []
                    characters = []
                    availableStatuses = []
                    availableSpecies = []
                    availableTypes = []
                    isLoading = false
                }
            }
        }
    }
    
    private func updateAvailableFilters() {
        // Extract unique statuses
        availableStatuses = Array(Set(allCharacters.map { $0.status })).sorted()
        
        // Extract unique species
        availableSpecies = Array(Set(allCharacters.map { $0.species })).sorted()
        
        // Extract unique types (excluding empty strings)
        availableTypes = Array(Set(allCharacters.map { $0.type }.filter { !$0.isEmpty })).sorted()
    }
    
    private func applyFilters() {
        var filtered = allCharacters
        
        // Apply status filter
        if let status = selectedStatus {
            filtered = filtered.filter { $0.status.lowercased() == status.lowercased() }
        }
        
        // Apply species filter
        if let species = selectedSpecies {
            filtered = filtered.filter { $0.species.lowercased() == species.lowercased() }
        }
        
        // Apply type filter
        if let type = selectedType, !type.isEmpty {
            filtered = filtered.filter { $0.type.lowercased().contains(type.lowercased()) }
        }
        
        characters = filtered
    }
    
    func clearSearch() {
        searchTask?.cancel()
        searchText = ""
        allCharacters = []
        characters = []
        availableStatuses = []
        availableSpecies = []
        availableTypes = []
        isLoading = false
        errorMessage = nil
    }
    
    func clearFilters() {
        selectedStatus = nil
        selectedSpecies = nil
        selectedType = nil
    }
    
    var hasActiveFilters: Bool {
        selectedStatus != nil || selectedSpecies != nil || selectedType != nil
    }
}
