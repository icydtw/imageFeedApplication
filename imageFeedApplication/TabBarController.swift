import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let profileViewController = ProfileViewController()
        let profileHelper = ProfileHelper()
        let presenterForProfile = ProfileViewPresenter(helper: profileHelper)
        profileViewController.configure(presenterForProfile)
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        let presenterForImagesList = ImagesListViewPresenter()
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        imagesListViewController.configure(presenterForImagesList)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
