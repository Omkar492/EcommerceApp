//
//  NetworkError.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

nonisolated enum NetworkError: Error, LocalizedError {
    case transport(URLError)
    case invalidResponse
    case httpStatus(code: Int)
    case decodingFailed(Error)
    case unknown(Error)
    
    var statusCode: Int? {
        guard case .httpStatus(let code) = self else {
            return nil
        }
        return code
    }

    var userMessage: String {
        switch self {
        case .transport(let urlError):
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection"
            case .timedOut:
                return "Request timed out"
            default:
                return "Network error occured"
            }
        case .invalidResponse:
            return "Invalid response from server."
        case .httpStatus(code: let code):
            switch code {
            case 401:
                return "You are not authorized 401 Unauthorized"
            case 403:
                return "You do not have permissiong 403 Forbidden"
            case 404:
                return "404 Not Found"
            case 409:
                return "Action conflicts with existing data 409 Conflict."
            case 429:
                return "Rate limit hit 429 Too Many Requests."
            case 500...599:
                return "Server error 5xx."
            default:
                return "Something went wrong. please try again."
            }
        case .decodingFailed(let error):
            return "Failed to decode data. \(error.localizedDescription)"
        case .unknown(let error):
            return "An unknown error occured. \(error.localizedDescription)"
        }
    }
    
    var debugMessage: String {
        switch self {
        case .transport(let urlError):
            return "Transport error: \(urlError.code.rawValue) \(urlError.localizedDescription)"
        case .invalidResponse:
            return "invalid response from server."
        case .httpStatus(code: let code):
            return "HTTP \(code)"
        case .decodingFailed(let error):
            return "Decoding failed: \(error)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    var errorDescription: String? { userMessage }
}

nonisolated enum NetworkErrorMapper {
    static func map(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        
        if let urlError = error as? URLError {
            return .transport(urlError)
        }
        
        return .unknown(error)
    }
    
    static func httpStatus(code: Int) -> NetworkError {
        return .httpStatus(code: code)
    }
    
    static func decodeFailure(_ error: Error) -> NetworkError {
        return .decodingFailed(error)
    }
}
