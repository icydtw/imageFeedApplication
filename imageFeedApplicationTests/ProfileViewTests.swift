import XCTest
import imageFeedApplication
@testable import imageFeedApplication

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: imageFeedApplication.ProfileViewControllerProtocol?
    var isViewDidLoad: Bool = false
    
    func viewDidLoad() {
        isViewDidLoad = true
    }
    
    func getProfileDetails() -> imageFeedApplication.Profile? {
        return nil
    }
    
    func getProfileImageURL() -> URL? {
        return nil
    }
    
    func logOut() -> UIAlertController {
        return UIAlertController()
    }
    
    
}

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let profileView = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        profileView.presenter = presenter
        presenter.view = profileView
        
        //when
        profileView.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.isViewDidLoad)
    }
    
    func testLogOut() {
        //given
        let helper = ProfileHelper()
        let presenter = ProfileViewPresenter(helper: helper)
        OAuth2TokenStorage.shared.token = "token"
        
        //when
        presenter.logOut()
        
        //then
        XCTAssertNil(OAuth2TokenStorage.shared.token)
    }
    
    func testMakeAlert() {
        //given
        let helper = ProfileHelper()
        let presenter = ProfileViewPresenter(helper: helper)
        
        //when
        let result = presenter.logOut()
        
        //then
        XCTAssertTrue(type(of: result) == UIAlertController.self)
    }
}
