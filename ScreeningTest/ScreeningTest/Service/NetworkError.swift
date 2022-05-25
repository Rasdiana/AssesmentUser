//
//  NetworkError.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 24/05/22.
//
import UIKit

public enum NetworkError: Error {
    case domainError
    case decodingError
    case internalError
    case notFound
    case noInternetConnection
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "Please check your connection"
        case .notFound:
            return "Resource not found"
        case .internalError:
            return "Something wrong with our server"
        default:
            return "Request Error"
        }
    }
}
