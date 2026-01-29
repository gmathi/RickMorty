//
//  RMAPIClientProtocol.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import Foundation

protocol RMAPIClientProtocol {
    func searchCharacters(name: String) async throws -> [Character]
}
