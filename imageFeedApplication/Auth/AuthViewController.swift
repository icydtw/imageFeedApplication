import Foundation
import UIKit

class AuthViewController: UIViewController, UIWebViewDelegate {
    let authViewID = "ShowWebView"
    let tokenStorage = OAuth2TokenStorage()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authViewID {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Ошибка!")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        let auth = OAuth2Service()
        auth.fetchAuthToken(code: code) { result in
            switch result {
            case .success(let accessKey):
                self.tokenStorage.token = accessKey
            case .failure(_):
                return
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
