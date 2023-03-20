import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol?
}
