//
//  AuthEndpointPath.swift
//  DemoApp
//
//  Created by Omkar Chougule on 10/05/26.
//

import Foundation

nonisolated enum AuthEndpointPath {
    case login
    case profile
    case refreshToken
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .profile:
            return "auth/profile"
        case .refreshToken:
            return "auth/refresh-token"
        }
    }
}
