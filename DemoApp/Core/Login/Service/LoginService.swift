//
//  LoginService.swift
//  DemoApp
//
//  Created by Omkar Chougule on 08/05/26.
//

import Foundation

protocol LoginServiceProtocol {
    func login(email: String, password: String) async throws -> AuthTokens
    func register(payload: CreateUserRequest) async throws -> User
    func checkEmailAvailability(email: String) async throws -> Bool
    func fetchProfile(accessToken: String) async throws -> User
    func refreshTokens(refreshToken: String) async throws -> AuthTokens
}


class LoginService: LoginServiceProtocol {
    private let client: APIClient
    
    init() {
        self.client = APIClient(baseURL: URLConstants.baseURL)
    }
    
    func login(email: String, password: String) async throws -> AuthTokens {
        let payload = LoginRequest(email: email, password: password)
        let requestModel = try APIRequest<AuthTokens>(
            method: .post,
            path: .auth(.login),
            body: payload
        )
        return try await client.execute(requestModel)
    }
    
    func register(payload: CreateUserRequest) async throws -> User {
        let requestModel = try APIRequest<User>(
            method: .post,
            path: .users(.users),
            body: payload
        )
        return try await client.execute(requestModel)
    }
    
    func checkEmailAvailability(email: String) async throws -> Bool {
        let payload = CheckEmailAvailabilityRequest(email: email)
        let requestModel = try APIRequest<CheckEmailAvailabilityResponse>(
            method: .post,
            path: .users(.isAvailable),
            body: payload
        )
        let response = try await client.execute(requestModel)
        return response.isAvailable
    }
    
    func fetchProfile(accessToken: String) async throws -> User {
        let requestModel = APIRequest<User>(
            method: .get,
            path: .auth(.profile),
            headers: authorizationHeaders(accessToken: accessToken)
        )
        return try await client.execute(requestModel)
    }
    
    func refreshTokens(refreshToken: String) async throws -> AuthTokens {
        let payload = RefreshTokenRequest(refreshToken: refreshToken)
        let requestModel = try APIRequest<AuthTokens>(
            method: .post,
            path: .auth(.refreshToken),
            body: payload
        )
        return try await client.execute(requestModel)
    }
    
    private func authorizationHeaders(accessToken: String) -> [String: String] {
        ["Authorization": "Bearer \(accessToken)"]
    }
}

struct MockLoginService: LoginServiceProtocol {
    func login(email: String, password: String) async throws -> AuthTokens {
        AuthTokens(accessToken: "mock-access-token", refreshToken: "mock-refresh-token")
    }
    
    func register(payload: CreateUserRequest) async throws -> User {
        User(
            id: 24,
            name: payload.name,
            email: payload.email,
            password: payload.password,
            avatar: payload.avatar,
            role: "customer",
            creationAt: nil,
            updatedAt: nil
        )
    }
    
    func checkEmailAvailability(email: String) async throws -> Bool {
        true
    }
    
    func fetchProfile(accessToken: String) async throws -> User {
        User.mock
    }
    
    func refreshTokens(refreshToken: String) async throws -> AuthTokens {
        AuthTokens(accessToken: "mock-refreshed-access-token", refreshToken: "mock-refreshed-refresh-token")
    }
}
