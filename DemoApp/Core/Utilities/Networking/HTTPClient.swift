//
//  HTTPClient.swift
//  DemoApp
//
//  Created by Codex on 24/05/26.
//

import Foundation

nonisolated protocol HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

nonisolated struct URLSessionHTTPClient: HTTPClient {
    var session: URLSession = .shared

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
