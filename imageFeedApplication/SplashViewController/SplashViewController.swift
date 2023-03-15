import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let auth = OAuth2Service.shared
    private let rootController = UIApplication.shared.windows.first?.rootViewController
    private let logoImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token =  OAuth2TokenStorage.shared.token {
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewControllerID") as? AuthViewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBar() {
        guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthViewController() {
        guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
        let authViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "AuthViewControllerID")
        window.rootViewController = authViewController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        switchToAuthViewController()
        fetchOAuthToken(code)
        UIBlockingProgressHUD.show()
    }
    
    private func fetchOAuthToken(_ code: String) {
        auth.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                UIApplication.shared.windows.first?.rootViewController?.present(self.showAlert(), animated: true)
                return
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(token: token, username: profile.username ?? "") { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBar()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                return
            }
        }
    }
}

extension SplashViewController {
    func showAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .cancel)
        alert.addAction(action)
        self.view.layer.backgroundColor = UIColor(named: "YP Black")?.cgColor
        return alert
    }
    
    func setupSplashScreen() {
        view.backgroundColor = UIColor(named: "YP Black")
        if let image = UIImage(named: "logo_P") {
            logoImage.image = image
        }
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
