import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token =  OAuth2TokenStorage.shared.token {
            fetchProfile(token: token)
            switchToTabBar()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBar() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarViewController")
            window.rootViewController = tabBarController
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        let auth = OAuth2Service()
        auth.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                self.fetchProfile(token: token)
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { return assertionFailure("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
