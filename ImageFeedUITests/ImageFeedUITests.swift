//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Konstantin Zuykov on 18.05.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    // MARK: Unisplash credentials and test name
    
    private let unisplashLogin = "zksystem@yahoo.com"      // Insert your e-mail here
    private let unisplashPassword = "*******************"  // Insert your password here
    private let desiredUserNickName = "@zksystem"          // Insert your profile nickname
    private let desiredUserFullName = "Konstantin Zuykov"   // Insert your full profile name
    
    // MARK: User interface accessibility identifiers
    
    private let likeButtonName = "likeButton"
    private let logoutButtonName = "ipad.and.arrow.forward"
    private let loginWebButtonName = "Login"
    private let doneToolbarButtonName = "Done"
    private let backToolbarButtonName = "backButton"
    private let unisplashWebViewName = "UnsplashWebView"
    private let ruButtonEnter = "Войти"
    private let ruButtonExit = "Выход"
    private let ruButtonYes = "Да"
    
    // MARK: Tests area
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        sleep(5)
        app.buttons[ruButtonEnter].tap()
        
        let webView = app.webViews[unisplashWebViewName]
        XCTAssertTrue(webView.waitForExistence(timeout: 15))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 15))
        
        loginTextField.tap()
        loginTextField.typeText(unisplashLogin)
        app.toolbars.buttons[doneToolbarButtonName].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 15))
        
        passwordTextField.tap()
        passwordTextField.typeText(unisplashPassword)
        app.toolbars.buttons[doneToolbarButtonName].tap()
        
        webView.buttons[loginWebButtonName].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        sleep(5)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp(velocity: 15)
        
        sleep(5)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 2)
        let likeButton = cellToLike.buttons[likeButtonName]
        
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))  // wait button for existance
        
        likeButton.tap() // tap 'like'
        sleep(5)
        
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))  // wait button for existance
        
        let likeButton2 = cellToLike.buttons[likeButtonName]
        likeButton2.tap() // tap 'like' again
        sleep(5)
        
        cellToLike.tap() // tap to imageCell
        
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons[backToolbarButtonName]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[desiredUserFullName].exists)
        XCTAssertTrue(app.staticTexts[desiredUserNickName].exists)
        app.buttons[logoutButtonName].tap()
        app.alerts[ruButtonExit].scrollViews.otherElements.buttons[ruButtonYes].tap()
        
        sleep(2)
        
        XCTAssertTrue(app.buttons[ruButtonEnter].exists)
    }
}
