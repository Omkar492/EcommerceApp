//
//  RetryEngine.swift
//  DemoApp
//
//  Created by Codex on 24/05/26.
//

import Foundation

nonisolated struct RetryConfiguration {
    var maxAttempts = 3
    var baseDelayNanoseconds: UInt64 = 300_000_000
    var retryableStatusCodes = Set([408, 429] + Array(500...599))
    var retryableURLErrorCodes: Set<URLError.Code> = [
        .cannotConnectToHost,
        .cannotFindHost,
        .dnsLookupFailed,
        .internationalRoamingOff,
        .networkConnectionLost,
        .notConnectedToInternet,
        .timedOut
    ]
    var retryableMethods: Set<String> = ["GET", "HEAD", "PUT", "DELETE", "OPTIONS"]
}

nonisolated struct RetryEngine: HTTPClient {
    private let client: any HTTPClient
    private let configuration: RetryConfiguration

    init(client: any HTTPClient, configuration: RetryConfiguration = RetryConfiguration()) {
        self.client = client
        self.configuration = configuration
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let maxAttempts = max(1, configuration.maxAttempts)
        var attempt = 1

        while true {
            try Task.checkCancellation()

            do {
                let (data, response) = try await client.data(for: request)

                if
                    attempt < maxAttempts,
                    canRetry(request),
                    let httpResponse = response as? HTTPURLResponse,
                    configuration.retryableStatusCodes.contains(httpResponse.statusCode)
                {
                    try await delay(beforeAttempt: attempt)
                    attempt += 1
                    continue
                }

                return (data, response)
            } catch is CancellationError {
                throw CancellationError()
            } catch let error as URLError where error.code == .cancelled {
                throw CancellationError()
            } catch {
                guard
                    attempt < maxAttempts,
                    canRetry(request),
                    shouldRetry(error)
                else {
                    throw error
                }

                try await delay(beforeAttempt: attempt)
                attempt += 1
            }
        }
    }

    private func canRetry(_ request: URLRequest) -> Bool {
        let method = request.httpMethod ?? HTTPMethod.get.rawValue
        return configuration.retryableMethods.contains(method)
    }

    private func shouldRetry(_ error: Error) -> Bool {
        guard let urlError = error as? URLError else { return false }
        return configuration.retryableURLErrorCodes.contains(urlError.code)
    }

    private func delay(beforeAttempt attempt: Int) async throws {
        guard configuration.baseDelayNanoseconds > 0 else { return }

        let multiplier = UInt64(1 << max(0, attempt - 1))
        try await Task.sleep(nanoseconds: configuration.baseDelayNanoseconds * multiplier)
    }
}
