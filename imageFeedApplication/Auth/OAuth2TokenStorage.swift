import Foundation
import SwiftKeychainWrapper

enum TokenErrors: Error {
    case savingError
    case retrievingError
}

final class OAuth2TokenStorage {
    private let keychainWrapper = KeychainWrapper.standard
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: "Auth token")
        }
        set {
            if let newValue {
                keychainWrapper.set(newValue, forKey: "Auth token")
            } else {
                keychainWrapper.remove(forKey: "Auth token")
            }
        }
    }
}
