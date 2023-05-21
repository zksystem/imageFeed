//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Konstantin Zuykov on 17.05.2023.
//

import Foundation
import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var showAlertCalled: Bool = false
    
    func updateAvatar() { }
    func presentAuthViewController(authViewController: UIViewController) { }
    func updateProfileDetails(profile: ImageFeed.Profile) { }
    
    func showAlert(alert: UIAlertController) {
        showAlertCalled = true
    }
}
