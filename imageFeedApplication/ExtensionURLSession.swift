import Foundation

extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure("Ошибка в URLSession при обработке данных" as! Error))
                }
            }
            
        })
        return task
    }
}
