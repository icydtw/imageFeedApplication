import Foundation
import UIKit

enum getProfileImageError: Error {
    case urlError
    case dataError
    case imageError
}

struct UserResult: Codable {
    var profileImages: [String: String]?
    
    private enum CodingKeys: String, CodingKey {
        case profileImages = "profile_image"
    }
}

struct UserImages {
    var small: String?
    var medium: String?
    var large: String?
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange") //имя нотификации
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let url = URL(string: GetProfileImageURL + username) else {
            completion(.failure(getProfileImageError.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                guard let usersImage = success.profileImages?["small"] else {
                    completion(.failure(getProfileImageError.imageError))
                    return
                }
                self.avatarURL = usersImage
                completion(.success(usersImage))
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL" : self.avatarURL])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
