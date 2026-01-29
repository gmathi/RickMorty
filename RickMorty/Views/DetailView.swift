//
//  DetailView.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import SwiftUI

struct DetailView: View {
    let character: Character
    var namespace: Namespace.ID
    @State private var showShareSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                if geometry.size.width > geometry.size.height {
                    // Landscape layout
                    landscapeLayout(geometry: geometry)
                } else {
                    // Portrait layout
                    portraitLayout
                }
            }
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .accessibilityLabel("Share character")
                        .accessibilityHint("Share character image and information")
                        .accessibilityIdentifier("shareButton")
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(character: character)
        }
    }
    
    // Portrait layout
    private var portraitLayout: some View {
        VStack(alignment: .leading, spacing: 16) {
            characterImage(height: 300)
            characterDetails
        }
        .accessibilityIdentifier("detailViewPortrait")
    }
    
    // Landscape layout
    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        HStack(alignment: .top, spacing: 24) {
            characterImage(height: geometry.size.height * 0.8)
                .frame(maxWidth: geometry.size.width * 0.4)
            
            VStack(alignment: .leading, spacing: 16) {
                characterDetails
            }
            .frame(maxWidth: geometry.size.width * 0.5)
        }
        .padding(.horizontal, 16)
        .accessibilityIdentifier("detailViewLandscape")
    }
    
    // Character image component
    private func characterImage(height: CGFloat) -> some View {
        AsyncImage(url: URL(string: character.image)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .background(Color.gray.opacity(0.2))
                    .accessibilityLabel("Loading character image")
                    .accessibilityIdentifier("characterImageLoading")
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .clipped()
                    .matchedGeometryEffect(id: "image-\(character.id)", in: namespace)
                    .accessibilityLabel("Image of \(character.name)")
                    .accessibilityAddTraits(.isImage)
                    .accessibilityIdentifier("characterImage")
            case .failure:
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .foregroundColor(.gray)
                    .background(Color.gray.opacity(0.2))
                    .accessibilityLabel("Character image unavailable")
                    .accessibilityIdentifier("characterImagePlaceholder")
            @unknown default:
                EmptyView()
            }
        }
    }
    
    // Character details component
    private var characterDetails: some View {
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
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("characterDetailsSection")
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
                .accessibilityIdentifier("detailRowLabel_\(label.lowercased())")
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
                .accessibilityIdentifier("detailRowValue_\(label.lowercased())")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
        .accessibilityIdentifier("detailRow_\(label.lowercased())")
    }
}

// Share sheet for sharing character information
struct ShareSheet: UIViewControllerRepresentable {
    let character: Character
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        var items: [Any] = [character.shareableText]
        
        // Add image URL
        if let imageURL = URL(string: character.image) {
            items.append(imageURL)
        }
        
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationView {
        DetailView(
            character: Character(
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
            ),
            namespace: namespace
        )
    }
}

#Preview("Character without type") {
    @Previewable @Namespace var namespace
    NavigationView {
        DetailView(
            character: Character(
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
            ),
            namespace: namespace
        )
    }
}
