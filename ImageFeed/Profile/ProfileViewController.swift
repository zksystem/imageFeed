//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 22.01.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var greetMsgLabel: UILabel!
    
    @IBAction func logoutButtonAction(_ sender: Any) {
    }
    
}
