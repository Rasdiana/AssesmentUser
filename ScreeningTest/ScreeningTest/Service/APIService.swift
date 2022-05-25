//
//  APIService.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 24/05/22.
//

import Foundation

class APIService {
    func requestUserData<P: Codable>(params:P? = nil, completion: @escaping (Result<UserModel, NetworkError>) -> Void) {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300.0
        config.timeoutIntervalForResource = 300.0
        let session = URLSession(configuration: config)
        let param = params as! Int
        var request = URLRequest(url: URL(string: "https://reqres.in/api/users?page=\(param)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.domainError))
                }
                return
            }
            do {
                
                let posts = try JSONDecoder().decode(UserModel.self, from: data)
                completion(.success(posts))
            } catch {
                //                print(response)
                print(error.localizedDescription)
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 404:
                        completion(.failure(.notFound))
                    case 500:
                        completion(.failure(.internalError))
                    default:
                        completion(.failure(.decodingError))
                    };/*print(httpResponse.description)*/
                }
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}

