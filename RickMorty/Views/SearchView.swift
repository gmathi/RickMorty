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
                    
                    TextField("Search characters...", text: $viewModel.searchText)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
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
                }
                
                // Error message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                // Character list
                if !viewModel.isLoading && viewModel.errorMessage == nil {
                    if viewModel.characters.isEmpty && !viewModel.searchText.isEmpty {
                        // Empty state
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No characters found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.characters.isEmpty {
                        // Initial state
                        VStack(spacing: 12) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("Search for Rick and Morty characters")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Results list
                        List(viewModel.characters) { character in
                            NavigationLink(destination: DetailView(character: character)) {
                                CharacterRow(character: character)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.visible)
                        }
                        .listStyle(.plain)
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
