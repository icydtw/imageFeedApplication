import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey), //код доступа приложения
            URLQueryItem(name: "redirect_uri", value: RedirectURI), //URI, кот. обрабатывает успешную авторизацию пользователя
            URLQueryItem(name: "response_type", value: "code"), //тип ответа, который мы ожидаем
            URLQueryItem(name: "scope", value: AccessScope) //список доступов
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
        updateProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //добавление наблюдателя
        webView.addObserver(
            self, //добавляем себя в кач-ве наблюдателя
            forKeyPath: #keyPath(WKWebView.estimatedProgress), //указываем путь для наблюдения
            options: .new, //новое значение
            context: nil) //т. к. WebViewViewController - final, то это значение м. б. = nil
        updateProgress()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //удаление наблюдателя
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    //обработчик обновлений
    override func observeValue(forKeyPath keyPath: String?, of ofObject: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: ofObject, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) { //вызываем ф-цию code, возвращающую код авторизации
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel) //если код получен, навигация более невозможна
        } else {
            decisionHandler(.allow) //если кода нет, разрешаем навигацию дальше
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
