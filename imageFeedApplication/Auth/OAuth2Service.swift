import Foundation

enum NetworkError: Error {
    case decodeError(error: String)
    case responseError(error: String)
}

final class OAuth2Service {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                return
            }
        } else {
            if lastCode == code {
                return
            }
        }
        
        var urlComponents = URLComponents(string: UnsplashPostRequestURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        
        lastCode = code
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    self.lastCode = nil
                    self.task = nil
                }
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.responseError(error: "Response error: \(response.statusCode)")))
                    self.lastCode = nil
                    self.task = nil
                }
                return
            }
            
            guard let data = data else { return }
            do {
                let successResult = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(successResult.accessToken))
                    self.task = nil
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodeError(error: "Decode error")))
                    self.lastCode = nil
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}
