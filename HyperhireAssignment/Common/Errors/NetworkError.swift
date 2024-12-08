//
//  NetworkError.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case serverError(Int)
    case noConnection
    case timeout
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from the server"
        case .decodingError:
            return "Failed to process the server response"
        case .encodingError:
            return "Failed to encode request parameters"
        case .serverError(let code):
            return getServerErrorMessage(for: code)
        case .noConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .custom(let message):
            return message
        }
    }
    
    private func getServerErrorMessage(for code: Int) -> String {
        switch code {
        case 400:
            return "Bad request (400)"
        case 401:
            return "Unauthorized access (401)"
        case 403:
            return "Access forbidden (403)"
        case 404:
            return "Content not found (404)"
        case 500...599:
            return "Server error occurred"
        default:
            return "Error occurred (Code: \(code))"
        }
    }
}
