//
//  SearchView.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = CharacterSearchViewModel()
    @Namespace private var imageAnimation
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .accessibilityHidden(true)
                    
                    TextField("Search characters...", text: $viewModel.searchText)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .accessibilityLabel("Search characters")
                        .accessibilityHint("Enter character name to search")
                        .accessibilityIdentifier("searchTextField")
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .accessibilityLabel("Clear search")
                        .accessibilityHint("Clears the search text")
                        .accessibilityIdentifier("clearSearchButton")
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // Filters section - only show after successful search with results
                if !viewModel.isLoading && viewModel.errorMessage == nil && !viewModel.allCharacters.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            // Status filter
                            if !viewModel.availableStatuses.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Status")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Picker("Status", selection: $viewModel.selectedStatus) {
                                        Text("All").tag(nil as String?)
                                        ForEach(viewModel.availableStatuses, id: \.self) { status in
                                            Text(status).tag(status as String?)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .accessibilityLabel("Status filter")
                                    .accessibilityIdentifier("statusFilterPicker")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Species filter
                            if !viewModel.availableSpecies.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Species")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Picker("Species", selection: $viewModel.selectedSpecies) {
                                        Text("All").tag(nil as String?)
                                        ForEach(viewModel.availableSpecies, id: \.self) { species in
                                            Text(species).tag(species as String?)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .accessibilityLabel("Species filter")
                                    .accessibilityIdentifier("speciesFilterPicker")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Type filter
                            if !viewModel.availableTypes.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Type")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Picker("Type", selection: $viewModel.selectedType) {
                                        Text("All").tag(nil as String?)
                                        ForEach(viewModel.availableTypes, id: \.self) { type in
                                            Text(type).tag(type as String?)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .accessibilityLabel("Type filter")
                                    .accessibilityIdentifier("typeFilterPicker")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        // Clear filters button (only show if any filter is active)
                        if viewModel.hasActiveFilters {
                            Button(action: {
                                viewModel.clearFilters()
                            }) {
                                Text("Clear Filters")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                            .accessibilityLabel("Clear all filters")
                            .accessibilityIdentifier("clearFiltersButton")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    .accessibilityIdentifier("filtersSection")
                }
                
                // Loading indicator
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                        .accessibilityLabel("Loading characters")
                        .accessibilityIdentifier("loadingIndicator")
                }
                
                // Error message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityLabel("Error: \(errorMessage)")
                        .accessibilityIdentifier("errorMessage")
                }
                
                // Character list
                if !viewModel.isLoading && viewModel.errorMessage == nil {
                    if viewModel.characters.isEmpty && !viewModel.searchText.isEmpty {
                        // Empty state
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                                .accessibilityHidden(true)
                            Text("No characters found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("No characters found for your search")
                        .accessibilityIdentifier("emptyStateView")
                    } else if viewModel.characters.isEmpty {
                        // Initial state
                        VStack(spacing: 12) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                                .accessibilityHidden(true)
                            Text("Search for Rick and Morty characters")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Search for Rick and Morty characters")
                        .accessibilityIdentifier("initialStateView")
                    } else {
                        // Results list
                        List(viewModel.characters) { character in
                            NavigationLink(destination: DetailView(character: character, namespace: imageAnimation)) {
                                CharacterRow(character: character, namespace: imageAnimation)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.visible)
                            .accessibilityLabel("\(character.name), \(character.species)")
                            .accessibilityHint("Double tap to view details")
                            .accessibilityIdentifier("characterRow_\(character.id)")
                        }
                        .listStyle(.plain)
                        .accessibilityLabel("Search results")
                        .accessibilityIdentifier("characterList")
                    }
                }
                
                Spacer(minLength: 0)
            }
            .navigationTitle("Rick and Morty")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SearchView()
}
