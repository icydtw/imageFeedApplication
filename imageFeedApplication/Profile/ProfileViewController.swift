import Foundation
import UIKit

class ProfileViewController: UIViewController {
    private let profilePicture = UIImageView()
    private let usernameLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let statusLabel = UILabel()
    private let exitButtonView = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfilePicture()
        setupUsernameLabel()
        setupNicknameLabel()
        setupStatusLabel()
        setupExitButton()
        setupLayout()
        
        fetchProfile()
    }
    
    //Функции с кодом вёрстки
    private func setupProfilePicture() {
        if let profileImage = UIImage(named: "profile_photo") {
            profilePicture.image = profileImage
        }
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.layer.cornerRadius = 35
        profilePicture.layer.masksToBounds = true
    }
    
    private func setupUsernameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = "Загрузка..."
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    }
    
    private func setupNicknameLabel() {
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.text = "Загрузка..."
        nicknameLabel.textColor = UIColor(named: "YP Gray")
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func setupStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Загрузка..."
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func setupExitButton() {
        if let buttonImage = UIImage(named: "ipad.and.arrow.forward") {
            exitButtonView.setImage(buttonImage, for: .normal)
        }
        exitButtonView.addTarget(self, action: #selector(didExitButtonTap), for: .touchUpInside)
        exitButtonView.translatesAutoresizingMaskIntoConstraints = false
        exitButtonView.tintColor = UIColor(named: "YP Red")
    }
    
    private func setupLayout() {
        view.addSubview(profilePicture)
        view.addSubview(usernameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(statusLabel)
        view.addSubview(exitButtonView)
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalToConstant: 70),
            profilePicture.widthAnchor.constraint(equalToConstant: 70),
            profilePicture.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            exitButtonView.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor),
            exitButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    private func didExitButtonTap() {
        OAuth2TokenStorage.shared.token = nil
    }
    
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        let profileService = ProfileService()
        guard let token = OAuth2TokenStorage.shared.token else { return }
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.usernameLabel.text = profile.name
                self.nicknameLabel.text = profile.loginName
                self.statusLabel.text = profile.bio
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                return
            }
        }
    }
}
