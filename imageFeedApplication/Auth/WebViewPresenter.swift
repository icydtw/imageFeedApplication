import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
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
        view?.load(request: request)
    }
}
