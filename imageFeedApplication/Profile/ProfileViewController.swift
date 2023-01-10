//
//  ProfileViewController.swift
//  imageFeedApplication
//
//  Created by Илья Тимченко on 21.12.2022.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    var profilePic = UIImageView()
    var usernameLabel = UILabel()
    var nicknameLabel = UILabel()
    var statusLabel = UILabel()
    var buttonView = UIButton()
    
    override func viewDidLoad() {
        profilePictureMaker()
        usernameLabelMaker()
        nicknameLabelMaker()
        statusLabelMaker()
        buttonMaker()
    }
    
    //Функции с кодом вёрстки
    private func profilePictureMaker() {
        let profilePicture = UIImage(named: "profile_photo")
        let profilePictureView = UIImageView(image: profilePicture)
        profilePictureView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePictureView)
        profilePictureView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profilePictureView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profilePictureView.layer.cornerRadius = 35
        profilePictureView.layer.masksToBounds = true
        profilePictureView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profilePictureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        self.profilePic = profilePictureView
    }
    
    private func usernameLabelMaker() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.text = "Илья Тимченко"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23)
        label.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: profilePic.leadingAnchor).isActive = true
        self.usernameLabel = label
    }
    
    private func nicknameLabelMaker() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.text = "@icydtw"
        label.textColor = UIColor(named: "YP Gray")
        label.font = UIFont.systemFont(ofSize: 13)
        label.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
        self.nicknameLabel = label
    }
    
    private func statusLabelMaker() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.text = "Hello, world!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor).isActive = true
        self.nicknameLabel = label
    }
    
    private func buttonMaker() {
        let button = UIButton.systemButton(with: UIImage(named: "ipad.and.arrow.forward") ?? UIImage(), target: self, action: #selector(didExitButtonTap))
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.tintColor = UIColor(named: "YP Red")
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.buttonView = button
    }
    
    @objc
    func didExitButtonTap() {
        //Код кнопки
    }
}
