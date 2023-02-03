//
//  AuthViewController.swift
//  imageFeedApplication
//
//  Created by Илья Тимченко on 03.02.2023.
//

import Foundation
import UIKit

class AuthViewController: UIViewController, UIWebViewDelegate {
    let authViewID = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authViewID {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Ошибка!!!")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
