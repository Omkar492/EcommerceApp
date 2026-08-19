//
//  APIRequest.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

nonisolated enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

nonisolated struct EmptyResponse: Decodable { }

nonisolated struct APIRequest<Response: Decodable> {
    let method: HTTPMethod
    let path: APIRoutes
    var headers: [String: String]
    var body: Data?
    var queryItems: [URLQueryItem]
    
    init(
        method: HTTPMethod,
        path: APIRoutes,
        headers: [String : String] = [:],
        body: Data? = nil,
        queryItems: [URLQueryItem] = []
    ) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
        self.queryItems = queryItems
    }
    
    init<Body: Encodable>(
        method: HTTPMethod,
        path: APIRoutes,
        headers: [String : String] = [:],
        body: Body? = nil,
        encoder: JSONEncoder = JSONEncoder(),
        queryItems: [URLQueryItem] = []
    ) throws {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = try encoder.encode(body)
        self.queryItems = queryItems
        
        if self.headers["Content-Type"] == nil {
            self.headers["Content-Type"] = "application/json"
        }
    }
    
    func makeURLRequest(baseURL: URL, defaultHeaders: [String: String] = [:]) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path.path),
            resolvingAgainstBaseURL: true) else {
            throw URLError(.badURL)
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var mergedHeaders = defaultHeaders
        mergedHeaders.merge(headers, uniquingKeysWith: { _, new in new })
        request.allHTTPHeaderFields = mergedHeaders
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}
