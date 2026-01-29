//
//  CharacterDecodingTests.swift
//  RickMortyTests
//
//  Created by Govardhan Mathi on 1/28/26.
//

import XCTest
@testable import RickMorty

final class CharacterDecodingTests: XCTestCase {
    
    func testCharacterDecoding_ValidAPIResponse_DecodesSuccessfully() {
        // Given: A sample JSON response from the Rick and Morty API
        let jsonString = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
            },
            "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
            },
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to data")
            return
        }
        
        // When: We decode the JSON
        let decoder = JSONDecoder()
        let character: Character
        
        do {
            character = try decoder.decode(Character.self, from: jsonData)
        } catch {
            XCTFail("Failed to decode character: \(error)")
            return
        }
        
        // Then: All fields should be correctly decoded
        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, "Alive")
        XCTAssertEqual(character.species, "Human")
        XCTAssertEqual(character.type, "")
        XCTAssertEqual(character.gender, "Male")
        XCTAssertEqual(character.origin.name, "Earth (C-137)")
        XCTAssertEqual(character.origin.url, "https://rickandmortyapi.com/api/location/1")
        XCTAssertEqual(character.location.name, "Citadel of Ricks")
        XCTAssertEqual(character.location.url, "https://rickandmortyapi.com/api/location/3")
        XCTAssertEqual(character.image, "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        XCTAssertEqual(character.episode.count, 2)
        XCTAssertEqual(character.episode[0], "https://rickandmortyapi.com/api/episode/1")
        XCTAssertEqual(character.url, "https://rickandmortyapi.com/api/character/1")
        XCTAssertEqual(character.created, "2017-11-04T18:48:46.250Z")
    }
    
    func testCharacterResponseDecoding_ValidAPIResponse_DecodesSuccessfully() {
        // Given: A complete API response with info and results
        let jsonString = """
        {
            "info": {
                "count": 826,
                "pages": 42,
                "next": "https://rickandmortyapi.com/api/character/?page=2",
                "prev": null
            },
            "results": [
                {
                    "id": 1,
                    "name": "Rick Sanchez",
                    "status": "Alive",
                    "species": "Human",
                    "type": "",
                    "gender": "Male",
                    "origin": {
                        "name": "Earth (C-137)",
                        "url": "https://rickandmortyapi.com/api/location/1"
                    },
                    "location": {
                        "name": "Citadel of Ricks",
                        "url": "https://rickandmortyapi.com/api/location/3"
                    },
                    "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    "episode": [
                        "https://rickandmortyapi.com/api/episode/1"
                    ],
                    "url": "https://rickandmortyapi.com/api/character/1",
                    "created": "2017-11-04T18:48:46.250Z"
                }
            ]
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to data")
            return
        }
        
        // When: We decode the response
        let decoder = JSONDecoder()
        let response: CharacterResponse
        
        do {
            response = try decoder.decode(CharacterResponse.self, from: jsonData)
        } catch {
            XCTFail("Failed to decode response: \(error)")
            return
        }
        
        // Then: Info and results should be correctly decoded
        XCTAssertEqual(response.info.count, 826)
        XCTAssertEqual(response.info.pages, 42)
        XCTAssertEqual(response.info.next, "https://rickandmortyapi.com/api/character/?page=2")
        XCTAssertNil(response.info.prev)
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results[0].name, "Rick Sanchez")
    }
}
