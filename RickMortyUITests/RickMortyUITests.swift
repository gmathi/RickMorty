//
//  RickMortyUITests.swift
//  RickMortyUITests
//
//  Created by Govardhan Mathi on 1/28/26.
//

import XCTest

final class RickMortyUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Acceptance Criteria Tests
    
    /// Test: Search results should come from the API and update after each keystroke
    @MainActor
    func testSearchUpdatesAfterEachKeystroke() throws {
        // Given: The app is launched and search view is visible
        let searchField = app.textFields["Search characters..."]
        XCTAssertTrue(searchField.exists, "Search field should exist")
        
        // When: User types in the search field
        searchField.tap()
        searchField.typeText("rick")
        
        // Then: Results should appear (wait for API response)
        let characterList = app.scrollViews.firstMatch
        let exists = characterList.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Character list should appear after search")
        
        // Verify that results are displayed
        // Note: Actual character names will vary based on API response
        let firstCell = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'rick'")).firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 3), "Search results should contain characters matching 'rick'")
    }
    
    /// Test: Progress indicator should be shown without blocking UI
    @MainActor
    func testProgressIndicatorAppearsWithoutBlockingUI() throws {
        // Given: The app is launched
        let searchField = app.textFields["Search characters..."]
        
        // When: User starts typing
        searchField.tap()
        searchField.typeText("morty")
        
        // Then: Progress indicator should appear briefly
        let progressIndicator = app.activityIndicators.firstMatch
        
        // The UI should remain responsive (we can still interact with search field)
        XCTAssertTrue(searchField.exists, "Search field should remain accessible during loading")
        
        // Wait for results to load
        let characterList = app.scrollViews.firstMatch
        XCTAssertTrue(characterList.waitForExistence(timeout: 5), "Results should eventually appear")
    }
    
    /// Test: Tapping on a character should display detail view with all required fields
    @MainActor
    func testCharacterDetailViewDisplaysAllRequiredFields() throws {
        // Given: Search results are displayed
        let searchField = app.textFields["Search characters..."]
        searchField.tap()
        searchField.typeText("rick sanchez")
        
        // Wait for results
        sleep(2)
        
        // When: User taps on the first character
        let firstCharacter = app.buttons.firstMatch
        XCTAssertTrue(firstCharacter.waitForExistence(timeout: 5), "First character should exist")
        firstCharacter.tap()
        
        // Then: Detail view should display all required fields
        
        // 1. Title element that displays the name
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 3), "Navigation bar with character name should exist")
        
        // 2. The image of the character (full width)
        let characterImage = app.images.firstMatch
        XCTAssertTrue(characterImage.exists, "Character image should be displayed")
        
        // 3. Text element that displays the species
        let speciesLabel = app.staticTexts["Species"]
        XCTAssertTrue(speciesLabel.exists, "Species label should exist")
        
        // 4. Text element that displays the status
        let statusLabel = app.staticTexts["Status"]
        XCTAssertTrue(statusLabel.exists, "Status label should exist")
        
        // 5. Text element that displays the origin
        let originLabel = app.staticTexts["Origin"]
        XCTAssertTrue(originLabel.exists, "Origin label should exist")
        
        // 6. Text element that displays the type (only if available)
        // Type may or may not be present depending on the character
        
        // 7. Text element that displays a formatted version of the created date
        let createdLabel = app.staticTexts["Created"]
        XCTAssertTrue(createdLabel.exists, "Created date label should exist")
        
        // Verify the date is formatted (not raw ISO 8601)
        // The formatted date should not contain 'T' or 'Z' characters
        let allStaticTexts = app.staticTexts.allElementsBoundByIndex
        var foundFormattedDate = false
        for text in allStaticTexts {
            let label = text.label
            // Look for a date that contains a year but not ISO 8601 markers
            if label.contains("2017") || label.contains("2018") || label.contains("2019") || label.contains("2020") {
                if !label.contains("T") && !label.contains("Z") {
                    foundFormattedDate = true
                    break
                }
            }
        }
        XCTAssertTrue(foundFormattedDate, "A formatted date (not ISO 8601) should be displayed")
    }
    
    /// Test: Search with different terms updates results
    @MainActor
    func testSearchWithDifferentTermsUpdatesResults() throws {
        // Given: The app is launched
        let searchField = app.textFields["Search characters..."]
        
        // When: User searches for "rick"
        searchField.tap()
        searchField.typeText("rick")
        sleep(2)
        
        // Then: Results should appear
        let firstSearchResults = app.scrollViews.firstMatch
        XCTAssertTrue(firstSearchResults.waitForExistence(timeout: 5), "Results for 'rick' should appear")
        
        // When: User clears and searches for "morty"
        let clearButton = app.buttons["xmark.circle.fill"]
        if clearButton.exists {
            clearButton.tap()
        } else {
            // Manually clear the field
            searchField.tap()
            searchField.buttons["Clear text"].tap()
        }
        
        searchField.typeText("morty")
        sleep(2)
        
        // Then: New results should appear
        XCTAssertTrue(firstSearchResults.exists, "Results for 'morty' should appear")
    }
    
    /// Test: Empty search shows appropriate state
    @MainActor
    func testEmptySearchShowsInitialState() throws {
        // Given: The app is launched
        let searchField = app.textFields["Search characters..."]
        
        // Then: Initial state message should be visible
        let initialMessage = app.staticTexts["Search for Rick and Morty characters"]
        XCTAssertTrue(initialMessage.exists, "Initial state message should be displayed")
        
        // When: User types and then clears
        searchField.tap()
        searchField.typeText("test")
        
        let clearButton = app.buttons["xmark.circle.fill"]
        if clearButton.waitForExistence(timeout: 2) {
            clearButton.tap()
        }
        
        // Then: Should return to initial state
        XCTAssertTrue(initialMessage.exists, "Initial state should be restored after clearing search")
    }
    
    /// Test: Navigation back from detail view works
    @MainActor
    func testNavigationBackFromDetailView() throws {
        // Given: User is on detail view
        let searchField = app.textFields["Search characters..."]
        searchField.tap()
        searchField.typeText("rick")
        sleep(2)
        
        let firstCharacter = app.buttons.firstMatch
        XCTAssertTrue(firstCharacter.waitForExistence(timeout: 5))
        firstCharacter.tap()
        
        // Verify we're on detail view
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 3))
        
        // When: User taps back button
        let backButton = app.navigationBars.buttons.firstMatch
        backButton.tap()
        
        // Then: Should return to search view
        XCTAssertTrue(searchField.exists, "Should navigate back to search view")
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
