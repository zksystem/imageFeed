//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 17.05.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
        
    func viewDidLoad() {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = UnsplashHost
//        urlComponents.path = UnsplashAuthorizePath
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AccessKey),
//            URLQueryItem(name: "redirect_uri", value: RedirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: AccessScope)
//        ]
//
//        let url = urlComponents.url!
//        let request = URLRequest(url: url)

        let request = authHelper.authRequest()
        view?.load(request: request)

        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
        //        if let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == unsplashAuthorizeOAuth2String,
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
    }
    
}

