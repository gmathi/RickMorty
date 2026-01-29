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
    
    // MARK: - Helper Methods
    
    private func dismissKeyboard() {
        if app.keyboards.buttons["Return"].exists {
            app.keyboards.buttons["Return"].tap()
        }
    }
    
   

    // MARK: - Acceptance Criteria Tests
    
    /// Test: Search results should come from the API and update after each keystroke
    @MainActor
    func testBasicFunctionality() throws {

        let searchField = app/*@START_MENU_TOKEN@*/.textFields["searchTextField"]/*[[".otherElements",".textFields[\"Search characters\"]",".textFields[\"Search characters...\"]",".textFields[\"searchTextField\"]",".textFields"],[[[-1,3],[-1,2],[-1,1],[-1,4],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(searchField.exists, "Search field should exist")
        searchField.tap()
        searchField.typeText("Rick")
        dismissKeyboard()
        
        let character = app/*@START_MENU_TOKEN@*/.staticTexts["Rick Sanchez, Human"]/*[[".staticTexts",".matching(identifier: \"characterRowContent\").containing(.staticText, identifier: \"Rick Sanchez\")",".containing(.staticText, identifier: \"Rick Sanchez\")",".buttons.staticTexts[\"Rick Sanchez, Human\"]",".buttons[\"characterRow_1\"].staticTexts[\"characterRowContent\"]",".staticTexts[\"Rick Sanchez, Human\"]"],[[[-1,5],[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(character.exists, "Character list should appear after search")
        character.tap()
        
        // 1. Title element that displays the name
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 3), "Navigation bar with character name should exist")

        
        // 3. Text element that displays the species
        let speciesLabel = app.staticTexts["detailRowLabel_species"].firstMatch
        XCTAssertTrue(speciesLabel.exists, "Species label should exist")
        
        // 4. Text element that displays the status
        let statusLabel = app/*@START_MENU_TOKEN@*/.staticTexts["detailRowLabel_status"]/*[[".staticTexts",".staticTexts[\"Status\"]",".staticTexts[\"detailRowLabel_status\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(statusLabel.exists, "Status label should exist")
        
        // 5. Text element that displays the origin
        let originLabel = app/*@START_MENU_TOKEN@*/.staticTexts["detailRowLabel_origin"]/*[[".staticTexts",".staticTexts[\"Origin\"]",".staticTexts[\"detailRowLabel_origin\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(originLabel.exists, "Origin label should exist")
        
        // 6. Text element that displays the type (only if available)
        // Type may or may not be present depending on the character
        
        // 7. Text element that displays a formatted version of the created date
        let createdLabel = app/*@START_MENU_TOKEN@*/.staticTexts["detailRowLabel_created"]/*[[".staticTexts",".staticTexts[\"Created\"]",".staticTexts[\"detailRowLabel_created\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(createdLabel.exists, "Created date label should exist")
        
    }
    
    /// Test: Progress indicator should be shown without blocking UI
   
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
