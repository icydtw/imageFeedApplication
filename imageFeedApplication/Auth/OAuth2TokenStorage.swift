import Foundation
import SwiftKeychainWrapper

enum tokenErrors: Error {
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
            keychainWrapper.set(newValue ?? "", forKey: "Auth token")
        }
    }
}
