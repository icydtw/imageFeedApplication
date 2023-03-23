import Foundation
import WebKit
import UIKit

protocol ProfileHelperProtocol {
    func makeAlert() -> UIAlertController
}

class ProfileHelper: ProfileHelperProtocol {
    func makeAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { (_) in
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                }
            }
            guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
            let splashScreen = SplashViewController()
            window.rootViewController = splashScreen
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        return alert
    }
}
