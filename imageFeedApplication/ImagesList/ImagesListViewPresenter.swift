import Foundation

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func isNeedToFetchNextPage(row: Int)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    init(view: ImagesListViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func viewDidLoad() {
        observe()
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    func observe() {
        NotificationCenter.default.addObserver(forName: ImagesListService.notificationPhotos, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.view?.updateTableViewAnimated()
        }
        self.view?.updateTableViewAnimated()
    }
    
    func isNeedToFetchNextPage(row: Int) {
        if (row + 1) == ImagesListService.shared.photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}
