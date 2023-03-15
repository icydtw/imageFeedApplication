//
//  ImagesListService.swift
//  imageFeedApplication
//
//  Created by Илья Тимченко on 15.03.2023.
//

import Foundation

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
    static let notification = Notification.Name(rawValue: "photoAdded")
    static let shared = ImagesListService()
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        
        if let lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 1
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
                NotificationCenter.default.post(name: ImagesListService.notification, object: self)
            case .failure(let error):
                print("Произошла ошибка: \(error)")
            }
            self.task = nil
        }.resume()
    }
}
