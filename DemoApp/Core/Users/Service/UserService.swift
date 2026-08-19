//
//  UserService.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
    func createUser(payload: CreateUserRequest) async throws -> User
    func updateUser(_ id: Int, payload: UpdateUserRequest) async throws -> User
    func checkEmailAvailability(email: String) async throws -> Bool
}

struct UserService: UserServiceProtocol {
    private let client: APIClient
    
    init() {
        self.client = APIClient(baseURL: URLConstants.baseURL)
    }
    
    func fetchUsers() async throws -> [User] {
        let requestModel = APIRequest<[User]>(method: .get, path: .users(.users))
        return try await client.execute(requestModel)
    }
    
    func createUser(payload: CreateUserRequest) async throws -> User {
        let requestModel = try APIRequest<User>(method: .post, path: .users(.users), body: payload)
        return try await client.execute(requestModel)
    }
    
    func updateUser(_ id: Int, payload: UpdateUserRequest) async throws -> User {
        let requestModel = try APIRequest<User>(method: .put, path: .users(.byId(id)), body: payload)
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
}

struct MockUserService: UserServiceProtocol {
    func fetchUsers() async throws -> [User] {
        return User.mockUsers
    }
    
    func createUser(payload: CreateUserRequest) async throws -> User {
        return User.mockUsers.first!
    }
    
    func updateUser(_ id: Int, payload: UpdateUserRequest) async throws -> User {
        return User.mockUsers.first!
    }
    
    func checkEmailAvailability(email: String) async throws -> Bool {
        return true
    }
}
