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
}

struct UrlsResult: Codable {
    let full: String?
    let thumb: String?
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
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
    private var nextPage: Int?
    
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
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(OAuth2TokenStorage.shared.token)", forHTTPHeaderField: "Authorization")
        
        let session = urlSession
        session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
        }
    }
}
