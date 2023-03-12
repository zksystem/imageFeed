//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 12.02.2023.
//

import Foundation

final class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        var urlComponents = URLComponents(string: unsplashOAuth2TokenURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else { //Network errors handling
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else { // http errors handling
                completion(.failure(response.statusCode as! Error))
                return
            }
            
            do {
                let responseBody = try JSONDecoder().decode(OAuth2TokenResponseBody.self, from: data)
                completion(.success(responseBody.accessToken))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
