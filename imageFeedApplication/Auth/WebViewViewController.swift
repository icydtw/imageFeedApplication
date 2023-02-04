//
//  WebViewViewController.swift
//  imageFeedApplication
//
//  Created by Илья Тимченко on 03.02.2023.
//

import Foundation
import UIKit
import WebKit

class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    @IBOutlet var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        var UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
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
        
        webView.navigationDelegate = self
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) { //вызываем ф-цию code, возвращающую код авторизации
            //TODO: process code
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
