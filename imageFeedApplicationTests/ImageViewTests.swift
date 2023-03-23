import XCTest
import imageFeedApplication
@testable import imageFeedApplication

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    var view: imageFeedApplication.ImagesListViewControllerProtocol?
    var isViewDidLoad: Bool = false
    
    func viewDidLoad() {
        isViewDidLoad = true
    }
    
    func isNeedToFetchNextPage(row: Int) { }
}

final class ImageViewTests: XCTestCase {
    func testViewControllerCallsDidLoad() {
        //given
        let imageView = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        imageView.presenter = presenter
        presenter.view = imageView
        
        //when
        imageView.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.isViewDidLoad)
    }
}
