import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
