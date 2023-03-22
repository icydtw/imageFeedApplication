import Foundation
import WebKit
import UIKit

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? {get set}
    func viewDidLoad()
    func getProfileDetails() -> Profile?
    func getProfileImageURL() -> URL?
    func logOut() -> UIAlertController
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var helper: ProfileHelperProtocol
    
    init(view: ProfileViewControllerProtocol? = nil, helper: ProfileHelperProtocol) {
        self.view = view
        self.helper = helper
    }
    
    func viewDidLoad() {
        observe()
    }
    
    func getProfileDetails() -> Profile? {
        guard let profile = ProfileService.shared.profile else {
            return nil
        }
        return profile
    }
    
    func observe() {
        _ = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
        view?.updateAvatar()
    }
    
    func getProfileImageURL() -> URL? {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else {return nil}
        return url
    }
    
    func logOut() -> UIAlertController {
        OAuth2TokenStorage.shared.token = nil
        return helper.makeAlert()
    }
}
