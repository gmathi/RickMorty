//
//  Character.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import Foundation

struct Character: Identifiable, Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var formattedCreatedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: created) else {
            return created
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
    
    var hasType: Bool {
        return !type.isEmpty
    }
}

struct Origin: Codable {
    let name: String
    let url: String
}

struct Location: Codable {
    let name: String
    let url: String
}
