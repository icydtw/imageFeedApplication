import Foundation
import UIKit

class SplashViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
        
        if let token = OAuth2TokenStorage().token {
            
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
}
