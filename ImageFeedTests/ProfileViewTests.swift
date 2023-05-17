//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Konstantin Zuykov on 17.05.2023.
//

import Foundation

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
            //Given
            let viewController = ProfileViewController()
            let presenter = ProfilePresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
            
            //When
            _ = viewController.view
            
            //Then
            XCTAssertTrue(presenter.viewDidLoadCalled)
        }
        
    func testProfileViewCallsLogout() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.logOut()
        
        XCTAssertTrue(presenter.logOutCalled)
    }

}
