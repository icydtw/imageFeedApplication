import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    var token: String? {
        get {
            userDefaults.string(forKey: "token")
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}
