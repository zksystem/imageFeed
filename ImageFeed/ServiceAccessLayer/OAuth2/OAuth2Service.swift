//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 12.02.2023.
//

import Foundation

final class OAuth2Service {
    
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
  
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionDataTask?
    private var lastCode: String?
    
    
    public func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        if lastCode == code {
            return
        }
        task?.cancel()
        lastCode = code
        
        let request = makeRequest(code: code)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil
                else { //Network errors handling
                    completion(.failure(error ?? URLError(.badServerResponse)))
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else { // http errors handling
                    completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    return
                }
                
                do {
                    let responseBody = try JSONDecoder().decode(OAuth2TokenResponseBody.self, from: data)
                    completion(.success(responseBody.accessToken))
                } catch let error {
                    completion(.failure(error))
                }
                
                self.task = nil
                if error != nil {
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
       
 
    private func makeRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents(string: unsplashOAuth2TokenURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {
            fatalError("Unable to create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
}
