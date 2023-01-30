//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 22.01.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var labelFullName: UILabel?
    private var labelUserName: UILabel?
    private var labelGreetings: UILabel?
    private var imageViewUserPic: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePhoto()
    }
    
    private func setProfilePhoto() {
        // Add userpic
        let profileImage = UIImage(named: "userpic")
        let imageViewUserPic = UIImageView(image: profileImage)
        imageViewUserPic.tintColor = .gray
        imageViewUserPic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewUserPic)
        imageViewUserPic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageViewUserPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageViewUserPic.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageViewUserPic.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.imageViewUserPic = imageViewUserPic
        
        // Add full name
        let labelFullName = UILabel()
        labelFullName.text = "Екатерина Новикова"
        labelFullName.font = UIFont.boldSystemFont(ofSize: 23.0)
        labelFullName.textColor = UIColor(named: "ypWhite")
        labelFullName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelFullName)
        labelFullName.leadingAnchor.constraint(equalTo: imageViewUserPic.leadingAnchor).isActive = true
        labelFullName.topAnchor.constraint(equalTo: imageViewUserPic.bottomAnchor, constant: 8).isActive = true
        self.labelFullName = labelFullName
        
        // Add username
        let labelUserName = UILabel()
        labelUserName.text = "@ekaterina_nov"
        labelUserName.font = UIFont.systemFont(ofSize: 13.0)
        labelUserName.textColor = UIColor(named: "ypWhite")
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelUserName)
        labelUserName.leadingAnchor.constraint(equalTo: labelFullName.leadingAnchor).isActive = true
        labelUserName.topAnchor.constraint(equalTo: labelFullName.bottomAnchor, constant: 8).isActive = true
        self.labelUserName = labelUserName
        
        // Add greetings message
        let labelGreetings = UILabel()
        labelGreetings.text = "Hello, world"
        labelGreetings.font = UIFont.systemFont(ofSize: 18.0)
        labelGreetings.textColor = UIColor(named: "ypWhite")
        labelGreetings.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelGreetings)
        labelGreetings.leadingAnchor.constraint(equalTo: labelUserName.leadingAnchor).isActive = true
        labelGreetings.topAnchor.constraint(equalTo: labelUserName.bottomAnchor, constant: 8).isActive = true
        self.labelGreetings = labelGreetings
        
        // Add logout button
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        button.tintColor = UIColor(named: "ypRed")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: imageViewUserPic.centerYAnchor).isActive = true
    }
    
    // Logout button handler
    
    @objc
    private func didTapButton() {
    }
    
    
    
}
