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
        self.imageViewUserPic = imageViewUserPic
        
        // Add full name
        let labelFullName = UILabel()
        labelFullName.text = "Екатерина Новикова"
        labelFullName.font = UIFont.systemFont(ofSize: 23.0)
        labelFullName.textColor = UIColor(named: "ypWhite")
        labelFullName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelFullName)
        self.labelFullName = labelFullName
        
        // Add username
        let labelUserName = UILabel()
        labelUserName.text = "@ekaterina_nov"
        labelUserName.font = UIFont.systemFont(ofSize: 13.0)
        labelUserName.textColor = UIColor(named: "ypGray")
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelUserName)
        self.labelUserName = labelUserName
        
        // Add greetings message
        let labelGreetings = UILabel()
        labelGreetings.text = "Hello, world"
        labelGreetings.font = UIFont.systemFont(ofSize: 13.0)
        labelGreetings.textColor = UIColor(named: "ypWhite")
        labelGreetings.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelGreetings)
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
        
        // Apply constraints
        NSLayoutConstraint.activate([
            imageViewUserPic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageViewUserPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imageViewUserPic.widthAnchor.constraint(equalToConstant: 70),
            imageViewUserPic.heightAnchor.constraint(equalToConstant: 70),

            labelFullName.leadingAnchor.constraint(equalTo: imageViewUserPic.leadingAnchor),
            labelFullName.topAnchor.constraint(equalTo: imageViewUserPic.bottomAnchor, constant: 8),
            
            labelUserName.leadingAnchor.constraint(equalTo: imageViewUserPic.leadingAnchor),
            labelUserName.topAnchor.constraint(equalTo: labelFullName.bottomAnchor, constant: 8),

            labelGreetings.leadingAnchor.constraint(equalTo: imageViewUserPic.leadingAnchor),
            labelGreetings.topAnchor.constraint(equalTo: labelUserName.bottomAnchor, constant: 8),

            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            button.centerYAnchor.constraint(equalTo: imageViewUserPic.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20)
        ]);
        
        
    }
    
    // Logout button handler
    
    @objc
    private func didTapButton() {
    }
    
    
    
}
