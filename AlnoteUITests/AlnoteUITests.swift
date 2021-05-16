//
//  AlnoteUITests.swift
//  AlnoteUITests
//
//  Created by KatarzynaJSz on 16/05/2021.
//  Copyright © 2021 enjelhutasoit. All rights reserved.
//

import XCTest

extension XCUIElement {
    func clearText(andReplaceWith newText:String? = nil) {
        tap()
        tap() //When there is some text, its parts can be selected on the first tap, the second tap clears the selection
        press(forDuration: 1.0)
        let selectAll = XCUIApplication().menuItems["Select All"]
        //For empty fields there will be no "Select All", so we need to check
        if selectAll.waitForExistence(timeout: 0.5), selectAll.exists {
            selectAll.tap()
            typeText(String(XCUIKeyboardKey.delete.rawValue))
        }
        if let newVal = newText { typeText(newVal) }
    }
}

class AlnoteUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
    }
    
    enum NoteScreen: String {
        
        case addButton
        case saveButton
        case cancelButton
        case deleteButton
        case noteTitleInput
        case noteContentInput
        case noteTitle
        
        var element: XCUIElement {
            switch self {
            case .addButton:
                return XCUIApplication().buttons["Add"]
            case .saveButton:
                return XCUIApplication().buttons["Save"]
            case .cancelButton:
                return XCUIApplication().buttons["Cancel"]
            case .deleteButton:
                return XCUIApplication().buttons["Delete"]
            case .noteTitleInput:
                return XCUIApplication().textFields["typeTitle"]
            case .noteContentInput:
                return XCUIApplication().textFields["noteText"]
            case .noteTitle:
                return XCUIApplication().staticTexts["noteTitle"]
            }
        }
    }
    

    func test01AddNote() throws {
        // Add a new note
        NoteScreen.addButton.element.tap()
        NoteScreen.noteTitleInput.element.tap()
        NoteScreen.noteTitleInput.element.typeText("My new note")
        NoteScreen.saveButton.element.tap()
        XCTAssertTrue(NoteScreen.noteTitle.element.exists)
        let myLabel = NoteScreen.noteTitle.element
        XCTAssertEqual("My new note", myLabel.label)
    }
    
    func test02EditNote() throws {
        // Edits an existing note
        XCTAssert(NoteScreen.noteTitle.element.waitForExistence(timeout: 5))
        NoteScreen.noteTitle.element.tap()
        NoteScreen.noteTitleInput.element.tap()
        NoteScreen.noteTitleInput.element.clearText(andReplaceWith: "edited note")
        NoteScreen.saveButton.element.tap()
        let myLabel = NoteScreen.noteTitle.element
        XCTAssertEqual("My new edited note", myLabel.label)
    }
    
    func test03DeleteNote() throws {
        // Deletes an existing note
        NoteScreen.noteTitle.element.swipeLeft()
        NoteScreen.deleteButton.element.tap()
        XCTAssertFalse(NoteScreen.noteTitle.element.exists)
    }
  
    override func tearDown() {
        super.tearDown()
    }
}
