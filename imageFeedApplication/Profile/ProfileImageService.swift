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
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(getProfileImageError.dataError))
                    self.task = nil
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(UserResult.self, from: data)
                DispatchQueue.main.async {
                    guard let usersImage = result.profileImages?["small"] else {
                        completion(.failure(getProfileImageError.imageError))
                        return
                    }
                    self.avatarURL = usersImage
                    completion(.success(usersImage))
                    NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL" : self.avatarURL])
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(getProfileImageError.dataError))
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}
