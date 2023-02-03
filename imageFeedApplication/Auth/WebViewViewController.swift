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
        dismiss(animated: true)
    }
    
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
    }
}
