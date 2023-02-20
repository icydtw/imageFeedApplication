import Foundation

let unsplashPostRequestURL = "https://unsplash.com/oauth/token"

class OAuth2Service {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        var urlComponents = URLComponents(string: unsplashPostRequestURL)!
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
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure("Ошибка номер \(response.statusCode)" as! Error))
                return
            }
            guard let data = data else { return }
            do {
                let successResult = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                completion(.success(successResult.accessToken))
            } catch {
                completion(.failure("Ошибка обработки данных" as! Error))
            }
        }
        task.resume()
    }
}
