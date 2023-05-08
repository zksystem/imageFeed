//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 05.03.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {

    //static let shared = OAuth2Service()

    private let oAuth2TokenStorage = OAuth2TokenStorage()

    private let oAuth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthToken()
    }
    
    private func checkAuthToken() {
        if oAuth2TokenStorage.token != nil {
            guard let token = oAuth2TokenStorage.token else {
                return
            }
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)


        } else {
            //performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController =
                    storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                return
            }

            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuth2Token(code)
        }
    }
    
    private func fetchOAuth2Token(_ code: String) {
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let token):
                self.oAuth2TokenStorage.token = token
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                _ = UIAlertController(title: "Error", message: "Can't login :(", preferredStyle: UIAlertController.Style.alert)
                break
            }
        }
    }
    
   
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {
                return
            }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username, token: token) { _ in }
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                _ = UIAlertController(title: "Error", message: "Can't fetch profile :(", preferredStyle: UIAlertController.Style.alert)
                break
            }
        }
    }
    
    
}
