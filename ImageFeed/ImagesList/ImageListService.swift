//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 08.05.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let fullImageURL: String
    let isLiked: Bool
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small : String
    let thumb: String
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
        case id, width, height, description, urls
    }
}

struct LikeResult: Decodable {
    let photo: PhotoResult
}

//

final class ImageListService {
    
    static let shared = ImageListService()
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    //--- fetch photos
    
    func fetchPhotosNextPage() {
        guard task == nil else {
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = (lastLoadedPage ?? 0) + 1
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard var request = makeRequest(path: "/photos?page=\(nextPage)&&per_page=10") else {
            return assertionFailure("Error photo request")
        }
        
        request.httpMethod = "GET"
        
        let task = urlSession.requestTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let photoResult):
                photoResult.forEach { photoResult in
                    let photo = Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: self.dateFormatter.date(from: photoResult.createdAt ?? ""),
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        fullImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser)
                    self.photos.append(photo)
                }
                
                NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: self,
                                                userInfo: ["photos": self.photos])
                
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
        
        if lastLoadedPage == nil {
            lastLoadedPage = 1
        } else {
            lastLoadedPage? += 1
        }
    }
    
    //--- change like state
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard var request = makeRequest(path: "/photos/\(photoId)/like") else { return assertionFailure("Error like request")}
        
        if isLike {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "DELETE"
        }
        
        _ = urlSession.requestTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        fullImageURL: photo.fullImageURL,
                        isLiked: !photo.isLiked)
                    self.photos[index] = newPhoto
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }    
    
    //--- request
    
    private func makeRequest(path: String) -> URLRequest? {
        guard let baseURL = URL(string: path, relativeTo: DefaultBaseURL) else {
            assertionFailure("url is nil")
            return nil
        }
        
        var request = URLRequest(url: baseURL)
        guard let token = OAuth2TokenStorage().token else {
            assertionFailure("token is nil")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
}
