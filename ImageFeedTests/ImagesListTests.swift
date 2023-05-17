//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Konstantin Zuykov on 18.05.2023.
//

import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //Given
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterConvertDate() {
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        presenter.photos = [
            Photo(id: "",
                  size: CGSize(),
                  createdAt: dateFormatter.date(from: "2016-07-10T11:00:01+0000"),
                  welcomeDescription: nil,
                  thumbImageURL: "",
                  fullImageURL: "",
                  isLiked: false)
        ]
        
        //When
        let date = presenter.makePhotoDate(row: 0)
        
        //Then
        XCTAssertTrue(date == "10 июля 2016 г.")
    }
}

