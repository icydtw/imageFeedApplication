import UIKit

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
    
    func convertToPhoto() -> Photo {
        return Photo(id: self.id, size: CGSize(width: self.width, height: self.height), createdAt: self.createdAt, welcomeDescription: self.description, thumbImageURL: self.urls?.thumb ?? "", largeImageURL: self.urls?.full ?? "", isLiked: self.likedByUser)
    }
}

struct UrlsResult: Codable {
    let full: String?
    let thumb: String?
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var nextPage = 0
    static let notificationPhotos = Notification.Name(rawValue: "photoAdded")
    static let notificationLikes = Notification.Name(rawValue: "likeChanged")
    static let shared = ImagesListService()
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        
        if let lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 3
        }
        
        guard var urlComponents = URLComponents(string: GetPhotosURL) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "5")
        ]
        guard let url = urlComponents.url,
              let token = OAuth2TokenStorage.shared.token else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = urlSession
        session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.lastLoadedPage = self.nextPage
                self.photos.append(contentsOf: result.map({$0.convertToPhoto()}))
                NotificationCenter.default.post(name: ImagesListService.notificationPhotos, object: self)
            case .failure(let error):
                print("Произошла ошибка: \(error)")
            }
            self.task = nil
        }.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if task != nil { return }
        
        guard var urlComponents = URLComponents(string: LikePhotosURL) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: photoId)
        ]
        guard let url = urlComponents.url,
              let token = OAuth2TokenStorage.shared.token else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = urlSession
        
        if isLike {
            request.httpMethod = "DELETE"
        } else {
            request.httpMethod = "POST"
        }
        
        session.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                NotificationCenter.default.post(name: ImagesListService.notificationLikes, object: self)
                print("\(photoId) liked")
            case .failure(let error):
                return
            }
        }
        
        // Поиск индекса элемента
        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
            // Текущий элемент
           let photo = self.photos[index]
           // Копия элемента с инвертированным значением isLiked.
           let newPhoto = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: !photo.isLiked
                )
            // Заменяем элемент в массиве.
            DispatchQueue.main.async {
                var futureNewPhotos = self.photos
                futureNewPhotos[index] = newPhoto
                self.photos = futureNewPhotos
            }
        }
    }
}
