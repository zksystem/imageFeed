//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 22.01.2023.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile)
    func updateAvatar()
}


final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    private let profileImageServiceNotification = ProfileImageService.didChangeNotification
    
    private var labelFullName: UILabel = {
        let labelFullName = UILabel()
        labelFullName.text = "Екатерина Новикова"
        labelFullName.font = UIFont.boldSystemFont(ofSize: 23.0)
        labelFullName.textColor = UIColor(named: "ypWhite")
        return labelFullName
    }()
    
    private var labelUserName: UILabel = {
        let labelUserName = UILabel()
        labelUserName.text = "@ekaterina_nov"
        labelUserName.font = UIFont.systemFont(ofSize: 13.0)
        labelUserName.textColor = UIColor(named: "ypGray")
        return labelUserName
    }()
    
    private var labelGreetings: UILabel = {
        let labelGreetings = UILabel()
        labelGreetings.text = "Hello, world"
        labelGreetings.font = UIFont.systemFont(ofSize: 13.0)
        labelGreetings.textColor = UIColor(named: "ypWhite")
        return labelGreetings
    }()
    
    private var imageViewUserPic: UIImageView = {
        let profileImage = UIImage(named: "userpic")
        let imageViewUserPic = UIImageView(image: profileImage)
        imageViewUserPic.tintColor = .gray
        imageViewUserPic.backgroundColor = .clear
        return imageViewUserPic
    }()
    
    private var buttonLogout: UIButton = {
        if let buttonImage = UIImage(systemName: "ipad.and.arrow.forward"){
            let buttonLogout = UIButton.systemButton(with: buttonImage, target: nil, action: #selector(didTapLogoutButton))
            buttonLogout.tintColor = UIColor(named: "ypRed")
            return buttonLogout
        } else {
            assertionFailure("Unable to create button with image")
            return UIButton()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        updateAvatar()
        initProfile()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: profileImageServiceObserver as? NSNotification.Name, object: nil)
    }
    
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        imageViewUserPic.kf.setImage(
            with: url,
            placeholder: UIImage(named: "person.crop.circle.fill"),
            options: [.processor(processor)]
        )
    }
    
    func updateProfileDetails(profile: Profile) {
        labelFullName.text = profile.name
        labelUserName.text = profile.loginName
        labelGreetings.text = profile.bio
    }
    
    private func initProfile() {
        // Add userpic
        imageViewUserPic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewUserPic)
        
        // Add full name
        labelFullName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelFullName)
        
        // Add username
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelUserName)
        
        // Add greetings message
        labelGreetings.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelGreetings)
        
        // Add logout button
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonLogout)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            imageViewUserPic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageViewUserPic.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            imageViewUserPic.widthAnchor.constraint(equalToConstant: 70),
            imageViewUserPic.heightAnchor.constraint(equalToConstant: 70),
            
            labelFullName.leadingAnchor.constraint(equalTo: imageViewUserPic.leadingAnchor),
            labelFullName.topAnchor.constraint(equalTo: imageViewUserPic.bottomAnchor, constant: 8),
            
            labelUserName.leadingAnchor.constraint(equalTo: imageViewUserPic.leadingAnchor),
            labelUserName.topAnchor.constraint(equalTo: labelFullName.bottomAnchor, constant: 8),
            
            labelGreetings.leadingAnchor.constraint(equalTo: imageViewUserPic.leadingAnchor),
            labelGreetings.topAnchor.constraint(equalTo: labelUserName.bottomAnchor, constant: 8),
            
            buttonLogout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            buttonLogout.centerYAnchor.constraint(equalTo: imageViewUserPic.centerYAnchor),
            buttonLogout.widthAnchor.constraint(equalToConstant: 20),
            buttonLogout.heightAnchor.constraint(equalToConstant: 22)
        ]);
    }
    
    @objc private func didTapLogoutButton() {
        let alert = UIAlertController(title: "Выход", message: "Вы желаете выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            presenter?.logOut()
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        self.present(alert, animated: true)
    }
    
    
    
}
