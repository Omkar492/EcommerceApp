//
//  RetryEngineTests.swift
//  DemoAppTests
//
//  Created by Codex on 24/05/26.
//

import Foundation
import Testing
@testable import DemoApp

struct RetryEngineTests {
    @Test func retriesIdempotentRequestsOnRetryableStatusCode() async throws {
        let request = URLRequest(url: URL(string: "https://example.com/products")!)
        let client = StubHTTPClient(responses: [
            .success(httpResponse(statusCode: 500)),
            .success(httpResponse(statusCode: 200, body: #"[]"#.data(using: .utf8) ?? Data()))
        ])
        let configuration = RetryConfiguration(maxAttempts: 2, baseDelayNanoseconds: 0)
        let engine = RetryEngine(client: client, configuration: configuration)

        let (_, response) = try await engine.data(for: request)

        #expect((response as? HTTPURLResponse)?.statusCode == 200)
        #expect(await client.callCount == 2)
    }

    @Test func doesNotRetryNonIdempotentRequests() async throws {
        var request = URLRequest(url: URL(string: "https://example.com/products")!)
        request.httpMethod = HTTPMethod.post.rawValue
        let client = StubHTTPClient(responses: [
            .success(httpResponse(statusCode: 500)),
            .success(httpResponse(statusCode: 200))
        ])
        let configuration = RetryConfiguration(maxAttempts: 2, baseDelayNanoseconds: 0)
        let engine = RetryEngine(client: client, configuration: configuration)

        let (_, response) = try await engine.data(for: request)

        #expect((response as? HTTPURLResponse)?.statusCode == 500)
        #expect(await client.callCount == 1)
    }

    @Test func treatsURLSessionCancellationAsTaskCancellation() async throws {
        let request = URLRequest(url: URL(string: "https://example.com/products")!)
        let client = StubHTTPClient(responses: [
            .failure(URLError(.cancelled))
        ])
        let configuration = RetryConfiguration(maxAttempts: 2, baseDelayNanoseconds: 0)
        let engine = RetryEngine(client: client, configuration: configuration)

        do {
            _ = try await engine.data(for: request)
            Issue.record("Expected CancellationError")
        } catch is CancellationError {
            #expect(await client.callCount == 1)
        } catch {
            Issue.record("Expected CancellationError, got \(error)")
        }
    }
}

private actor StubHTTPClient: HTTPClient {
    private var responses: [Result<(Data, URLResponse), Error>]
    private(set) var callCount = 0

    init(responses: [Result<(Data, URLResponse), Error>]) {
        self.responses = responses
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        callCount += 1

        guard !responses.isEmpty else {
            throw URLError(.badServerResponse)
        }

        return try responses.removeFirst().get()
    }
}

private func httpResponse(statusCode: Int, body: Data = Data()) -> (Data, URLResponse) {
    let url = URL(string: "https://example.com/products")!
    let response = HTTPURLResponse(
        url: url,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil
    )!
    return (body, response)
}
