//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Zuykov on 18.05.2023.
//

import Foundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func makePhotoUrl(photoNumber: Int) -> URL? {
        return nil
    }
    
    func makePhotoDate(row: Int) -> String {
        return ""
    }
    
    func changeLike(cell: ImagesListCell, row: Int) { }
}
