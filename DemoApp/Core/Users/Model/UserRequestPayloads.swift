//
//  CreateUserRequest.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//


import Foundation

struct CreateUserRequest: Encodable {
    let name: String
    let email: String
    let password: String
    let avatar: String
}

struct UpdateUserRequest: Encodable {
    let email: String?
    let name: String?
}

struct CheckEmailAvailabilityRequest: Encodable {
    let email: String
}

struct CheckEmailAvailabilityResponse: Decodable {
    let isAvailable: Bool
}
