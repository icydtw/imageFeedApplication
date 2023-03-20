import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    @IBOutlet private var progressView: UIProgressView!
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress,
                                                        options: [],
                                                        changeHandler: { [weak self] _, change in
            guard let self = self else { return }
            self.updateProgress()
        })
        
        webView.navigationDelegate = self
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey), //код доступа приложения
            URLQueryItem(name: "redirect_uri", value: redirectURI), //URI, кот. обрабатывает успешную авторизацию пользователя
            URLQueryItem(name: "response_type", value: "code"), //тип ответа, который мы ожидаем
            URLQueryItem(name: "scope", value: accessScope) //список доступов
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
        updateProgress()
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
