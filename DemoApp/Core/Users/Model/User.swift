//
//  User.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let password: String?
    let avatar: String?
    let role: String?
    let creationAt: String?
    let updatedAt: String?
}
extension User {
    static let mock: User = User(
        id: 1,
        name: "Alice Johnson",
        email: "alice@example.com",
        password: nil,
        avatar: "https://i.pravatar.cc/150?img=1",
        role: "customer",
        creationAt: "2026-02-23T10:15:30.000Z",
        updatedAt: "2026-03-09T08:45:10.000Z"
    )

    static let mockUsers: [User] = [
        User(
            id: 1,
            name: "Alice Johnson",
            email: "alice@example.com",
            password: nil,
            avatar: "https://i.pravatar.cc/150?img=1",
            role: "customer",
            creationAt: "2026-02-23T10:15:30.000Z",
            updatedAt: "2026-03-09T08:45:10.000Z"
        ),
        User(
            id: 2,
            name: "Bob Smith",
            email: "bob@example.com",
            password: nil,
            avatar: "https://i.pravatar.cc/150?img=2",
            role: "admin",
            creationAt: "2026-02-24T12:00:00.000Z",
            updatedAt: "2026-03-09T09:20:00.000Z"
        ),
        User(
            id: 3,
            name: "Carol Martinez",
            email: "carol@example.com",
            password: nil,
            avatar: "https://i.pravatar.cc/150?img=3",
            role: "seller",
            creationAt: "2026-02-25T14:30:00.000Z",
            updatedAt: "2026-03-09T11:05:00.000Z"
        ),
        User(
            id: 4,
            name: "David Lee",
            email: "david@example.com",
            password: nil,
            avatar: "https://i.pravatar.cc/150?img=4",
            role: "customer",
            creationAt: "2026-02-26T09:10:00.000Z",
            updatedAt: "2026-03-09T13:40:00.000Z"
        ),
        User(
            id: 5,
            name: "Evelyn Chen",
            email: "evelyn@example.com",
            password: nil,
            avatar: "https://i.pravatar.cc/150?img=5",
            role: "customer",
            creationAt: "2026-02-27T16:45:00.000Z",
            updatedAt: "2026-03-09T15:25:00.000Z"
        )
    ]
}

