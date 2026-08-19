//
//  UserEndpointPath.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

nonisolated enum UsersEndpointPath {
    case users
    case byId(Int)
    case isAvailable
    
    var path: String {
        switch self {
        case .users:
            return "users"
        case .byId(let id):
            return "users/\(id)"
        case .isAvailable:
            return "users/is-available"
        }
    }
}
