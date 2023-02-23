//
//  WebViewViewControllerDelegate.swift
//  imageFeedApplication
//
//  Created by Илья Тимченко on 03.02.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) //контроллер получил код
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) //пользователь отменил авторизацию
}
