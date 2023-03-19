import UIKit
import Kingfisher
import WebKit

class ProfileViewController: UIViewController {
    private let profilePicture = UIImageView()
    private let usernameLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let statusLabel = UILabel()
    private let exitButtonView = UIButton()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        setupProfilePicture()
        setupUsernameLabel()
        setupNicknameLabel()
        setupStatusLabel()
        setupExitButton()
        setupLayout()
        updateProfileDetails(profile: ProfileService.shared.profile ?? Profile())
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL, let url = URL(string: profileImageURL) else { return }
        profilePicture.kf.setImage(with: url, placeholder: UIImage(systemName: "face.smiling"))
    }
    
    private func updateProfileDetails(profile: Profile) {
        usernameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        statusLabel.text = profile.bio
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
    
    private func runAnimation() {
        
    }
    
    private func logOut() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { (_) in
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                }
            }
            guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
            let splashScreen = SplashViewController()
            window.rootViewController = splashScreen
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func didExitButtonTap() {
        OAuth2TokenStorage.shared.token = nil
        logOut()
    }
}
