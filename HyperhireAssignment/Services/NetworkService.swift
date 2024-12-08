//
//  NetworkService.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func request<T: Codable>(endpoint: Endpoint) async -> Result<T, NetworkError>
}

// MARK: - Network Service Implementation
final class NetworkService: NetworkServiceProtocol {
    private let session: URLSessionProtocol
    private let retryConfig: RetryConfig
    
    init(session: URLSessionProtocol = URLSession.shared, retryConfig: RetryConfig = .default) {
        self.session = session
        self.retryConfig = retryConfig
    }
    
    func request<T: Codable>(endpoint: Endpoint) async -> Result<T, NetworkError> {
        var attempt = 1
        var delay = retryConfig.initialDelay
        
        while attempt <= retryConfig.maxAttempts {
            let result = await performRequest(endpoint: endpoint) as Result<T, NetworkError>
            
            switch result {
            case .success:
                return result
                
            case .failure(let error):
                // Check if error is retryable
                if isRetryable(error) {
                    if attempt < retryConfig.maxAttempts {
                        // Wait before retrying
                        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                        
                        // Exponential backoff
                        delay = min(delay * retryConfig.multiplier, retryConfig.maxDelay)
                        attempt += 1
                        print("RTO, Request attempt \(attempt) with delay \(delay)")
                        continue
                    }
                }
                print("Max retry attempts exceeded")
                return .failure(.noConnection)
            }
        }
        return .failure(.noConnection)
    }
    
    private func isRetryable(_ error: NetworkError) -> Bool {
        switch error {
        case .noConnection, .timeout:
            // Always retry for connection issues and timeouts
            return true
        case .serverError(let code):
            // Only retry for 5xx server errors
            return code >= 500 && code < 600
        default:
            return false
        }
    }
    
    private func performRequest<T: Codable>(endpoint: Endpoint) async -> Result<T, NetworkError> {
        // Create URL
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        print("URL: ", url)
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        // Handle parameters
        if let parameters = endpoint.parameters {
            if endpoint.method == .get {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
                guard let url = components?.url else {
                    return .failure(.invalidURL)
                }
                print("URL param: ", url)
                request.url = url
            } else {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                } catch {
                    return .failure(.encodingError)
                }
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.serverError(0))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.serverError(httpResponse.statusCode))
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.decodingError)
            }
        } catch {
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                return .failure(.noConnection)
            } else if (error as NSError).code == NSURLErrorTimedOut {
                return .failure(.timeout)
            }
            return .failure(.custom(error.localizedDescription))
        }
    }
}
