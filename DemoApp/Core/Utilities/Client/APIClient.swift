//
//  APIClient.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

nonisolated struct APIClient {
    let baseURL: URL
    var httpClient: any HTTPClient
    var decoder: JSONDecoder = JSONDecoder()

    init(
        baseURL: URL,
        httpClient: (any HTTPClient)? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.httpClient = httpClient ?? RetryEngine(client: URLSessionHTTPClient())
        self.decoder = decoder
    }
    
    func execute<Response>(_ requestModel: APIRequest<Response>) async throws -> Response {
        do {
            let request = try requestModel.makeURLRequest(baseURL: baseURL)
            
            let (data, response) = try await httpClient.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.httpStatus(code: httpResponse.statusCode)
            }
            
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch {
            let mapped = NetworkErrorMapper.map(error)
            throw mapped
        }
    }
}
