//
//  ImageListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Zuykov on 18.05.2023.
//

import Foundation
@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
    }
    
    func showErrorAlert() {
    }
    
}
