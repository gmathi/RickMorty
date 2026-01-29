//
//  SearchView.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = CharacterSearchViewModel()
    
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
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .accessibilityLabel("Clear search")
                        .accessibilityHint("Clears the search text")
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // Loading indicator
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                        .accessibilityLabel("Loading characters")
                }
                
                // Error message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityLabel("Error: \(errorMessage)")
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
                    } else {
                        // Results list
                        List(viewModel.characters) { character in
                            NavigationLink(destination: DetailView(character: character)) {
                                CharacterRow(character: character)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.visible)
                            .accessibilityLabel("\(character.name), \(character.species)")
                            .accessibilityHint("Double tap to view details")
                        }
                        .listStyle(.plain)
                        .accessibilityLabel("Search results")
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
