//
//  DetailView.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import SwiftUI

struct DetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Full-width character image
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .background(Color.gray.opacity(0.2))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                    case .failure:
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .foregroundColor(.gray)
                            .background(Color.gray.opacity(0.2))
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Species
                    DetailRow(label: "Species", value: character.species)
                    
                    // Status
                    DetailRow(label: "Status", value: character.status)
                    
                    // Origin
                    DetailRow(label: "Origin", value: character.origin.name)
                    
                    // Type (conditional)
                    if character.hasType {
                        DetailRow(label: "Type", value: character.type)
                    }
                    
                    // Created date
                    DetailRow(label: "Created", value: character.formattedCreatedDate)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

// Helper view for label-value pairs
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationView {
        DetailView(character: Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "Genius Scientist",
            gender: "Male",
            origin: Origin(name: "Earth (C-137)", url: ""),
            location: Location(name: "Citadel of Ricks", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "",
            created: "2017-11-04T18:48:46.250Z"
        ))
    }
}

#Preview("Character without type") {
    NavigationView {
        DetailView(character: Character(
            id: 2,
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth (C-137)", url: ""),
            location: Location(name: "Earth (Replacement Dimension)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            episode: [],
            url: "",
            created: "2017-11-04T18:50:21.651Z"
        ))
    }
}
