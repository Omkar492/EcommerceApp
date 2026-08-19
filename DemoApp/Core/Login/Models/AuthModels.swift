//
//  AuthModels.swift
//  DemoApp
//
//  Created by Omkar Chougule on 10/05/26.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}

struct AuthTokens: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct AuthSession: Codable {
    let tokens: AuthTokens
    let user: User
}
