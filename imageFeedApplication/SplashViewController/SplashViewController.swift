import Foundation
import UIKit

class SplashViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
        
        if OAuth2TokenStorage().token != nil {
            print("Код есть, запускаем TabBar")
            switchToTabBar()
        } else {
            print("Кода нет, грузим Unsplash")
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    func switchToTabBar() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}
