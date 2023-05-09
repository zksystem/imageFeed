//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 17.04.2023.
//

import Foundation


struct UserResult: Codable {
    let profileImage: ImageResult
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageResult: Codable {
    let small: String
    let medium: String
    let large: String
}

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = makeRequest(token: token, username: username)
        let task = urlSession.requestTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let profileImage):
                self.avatarURL = profileImage.profileImage.medium
                completion(.success(profileImage.profileImage.medium))
                
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": profileImage.profileImage.medium])
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    
    private func makeRequest(token: String, username: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.path = unsplashUsersUrlString + "/\(username)"
        
        guard let url = urlComponents.url(relativeTo: defaultBaseURL) else {
            assertionFailure("Failed to create URL")
            return URLRequest(url: URL(string: "")!)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
