import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter: WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey), //код доступа приложения
            URLQueryItem(name: "redirect_uri", value: redirectURI), //URI, кот. обрабатывает успешную авторизацию пользователя
            URLQueryItem(name: "response_type", value: "code"), //тип ответа, который мы ожидаем
            URLQueryItem(name: "scope", value: accessScope) //список доступов
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
