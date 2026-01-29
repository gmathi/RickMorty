//
//  CharacterDateFormattingTests.swift
//  RickMortyTests
//
//  Created by Govardhan Mathi on 1/28/26.
//

import XCTest
@testable import RickMorty

final class CharacterDateFormattingTests: XCTestCase {
    
    func testFormattedCreatedDate_ValidISO8601Date_ReturnsFormattedString() {
        // Given: A character with a valid ISO 8601 date
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth (C-137)", url: ""),
            location: Location(name: "Citadel of Ricks", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "",
            created: "2017-11-04T18:48:46.250Z"
        )
        
        // When: We access the formattedCreatedDate
        let formattedDate = character.formattedCreatedDate
        
        // Then: The date should be formatted in a human-readable way
        // The exact format depends on locale, but it should NOT be the raw ISO string
        XCTAssertNotEqual(formattedDate, "2017-11-04T18:48:46.250Z", 
                         "Date should be formatted, not raw ISO 8601")
        XCTAssertFalse(formattedDate.contains("T"), 
                      "Formatted date should not contain 'T' separator")
        XCTAssertFalse(formattedDate.contains("Z"), 
                      "Formatted date should not contain 'Z' timezone indicator")
        
        // Should contain date components
        XCTAssertTrue(formattedDate.contains("2017"), 
                     "Formatted date should contain the year")
    }
    
    func testFormattedCreatedDate_InvalidDate_ReturnsOriginalString() {
        // Given: A character with an invalid date string
        let character = Character(
            id: 2,
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth (C-137)", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            episode: [],
            url: "",
            created: "invalid-date-string"
        )
        
        // When: We access the formattedCreatedDate
        let formattedDate = character.formattedCreatedDate
        
        // Then: It should return the original string as fallback
        XCTAssertEqual(formattedDate, "invalid-date-string",
                      "Invalid dates should return the original string")
    }
    
    func testFormattedCreatedDate_DifferentDates_ProducesDifferentFormats() {
        // Given: Two characters with different dates
        let character1 = Character(
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
        
        let character2 = Character(
            id: 2,
            name: "Morty",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "",
            created: "2020-05-15T10:30:00.000Z"
        )
        
        // When: We format both dates
        let date1 = character1.formattedCreatedDate
        let date2 = character2.formattedCreatedDate
        
        // Then: They should be different
        XCTAssertNotEqual(date1, date2, 
                         "Different dates should produce different formatted strings")
        XCTAssertTrue(date1.contains("2017"))
        XCTAssertTrue(date2.contains("2020"))
    }
}
