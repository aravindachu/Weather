//
//  NetworkManager.swift
//  Weather
//
//  Created by Aravind Vijayan on 01/03/22.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()

    func sendRequest<T>(url: String,
                        parameters: [String : Any]? = nil,
                        method: RequestMethod = .get,
                        completionHandler: @escaping ((Result<T?, NetworkError>)) -> Void) where T: Decodable  {
        guard let url = URL(string: url) else {
                completionHandler(.failure(.wrongURL))
                return
            }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        if let parameters = parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            urlRequest.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse, 200...300 ~= response.statusCode else {
                completionHandler(.failure(.unKnown))
                return
            }
            guard let data = data else {
                completionHandler(.success(nil))
                return
            }
            do {
                completionHandler(.success(try JSONDecoder().decode(T.self, from: data)))
            } catch {
                ///Log error
                completionHandler(.failure(.unKnown))
            }
        }.resume()

    }
}

enum NetworkError: Error {
    case unKnown
    case wrongURL
}

public enum RequestMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}

