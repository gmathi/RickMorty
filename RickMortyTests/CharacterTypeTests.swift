//
//  CharacterTypeTests.swift
//  RickMortyTests
//
//  Created by Govardhan Mathi on 1/28/26.
//

import XCTest
@testable import RickMorty

final class CharacterTypeTests: XCTestCase {
    
    func testHasType_EmptyString_ReturnsFalse() {
        // Given: A character with empty type
        let character = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "",
            created: "2017-11-04T18:48:46.250Z"
        )
        
        // When/Then: hasType should return false
        XCTAssertFalse(character.hasType, "Empty type string should return false")
    }
    
    func testHasType_NonEmptyString_ReturnsTrue() {
        // Given: A character with a type value
        let character = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "Genius Scientist",
            gender: "Male",
            origin: Origin(name: "Earth", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "",
            created: "2017-11-04T18:48:46.250Z"
        )
        
        // When/Then: hasType should return true
        XCTAssertTrue(character.hasType, "Non-empty type string should return true")
    }
}
