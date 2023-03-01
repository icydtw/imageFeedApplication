import Foundation

enum ProfileResultsError: Error {
    case urlError
    case dataError
}

struct ProfileResult: Codable {
    var userName: String
    var firstName: String?
    var lastName: String?
    var bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    var username: String?
    var name: String?
    var loginName: String?
    var bio: String?
}

final class ProfileService {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    static let shared = ProfileService()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let url = URL(string: GetProfileURL) else {
            completion(.failure(ProfileResultsError.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(ProfileResultsError.dataError))
                    self.task = nil
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userProfile = try decoder.decode(ProfileResult.self, from: data)
                DispatchQueue.main.async {
                    ProfileService.shared.profile = self.convertToProfile(userProfile)
                    completion(.success(self.convertToProfile(userProfile))) ///???
                    self.task = nil
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.success(Profile(username: "Ошибка загрузки", name: "Ошибка загрузки", loginName: "Ошибка загрузки", bio: "Ошибка загрузки")))
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func convertToProfile(_ profileResult: ProfileResult) -> Profile {
        let username = profileResult.userName
        let name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
        let loginName = "@\(profileResult.userName)"
        let bio = profileResult.bio
        return Profile(username: username, name: name, loginName: loginName, bio: bio)
    }
}
