//
//  Endpoint.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

struct APIEndpoint: Endpoint {
    let baseURL: String
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let parameters: [String: Any]?
    
    init(
        baseURL: String = "https://itunes.apple.com",
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
    }
}
