//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Zuykov on 17.05.2023.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

