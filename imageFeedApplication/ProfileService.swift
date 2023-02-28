import Foundation

struct ProfileResult: Codable {
    var userName: String
    var firstName: String
    var lastName: String
    var bio: String
    var urlsAvatars: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
        case urlsAvatars = "profile_image"
    }
}

struct Profile {
    
}

final class ProfileService {
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
    }
}
