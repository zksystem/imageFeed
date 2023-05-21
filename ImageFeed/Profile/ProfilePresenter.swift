//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 17.05.2023.
//

import Foundation
import WebKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logOut()
    func setNotificationObserver()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileImageServiceNotification = ProfileImageService.didChangeNotification
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        guard let profile = profileService.profile else {
            return
        }
        view?.updateProfileDetails(profile: profile)
        setNotificationObserver()
    }
    
    internal func logOut() {
        WebViewViewController.cleanCookies()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Error")
            return
        }
        
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
    
    func setNotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: profileImageServiceNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self?.view  else { return }
                self.updateAvatar()
            }
        guard let view = view else {return}
        view.updateAvatar()
    }
    
    
}
