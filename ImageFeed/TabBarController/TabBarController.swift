//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 08.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabProfile"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

