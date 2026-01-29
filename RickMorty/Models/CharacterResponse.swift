//
//  CharacterResponse.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import Foundation

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
