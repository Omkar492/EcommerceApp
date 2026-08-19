//
//  UserPath.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//


import Foundation

enum UserPath {
    case list
    case byID(Int)
    case emailAvailability

    var path: String {
        switch self {
        case .list:
            return "users"
        case .byID(let id):
            return "users/\(id)"
        case .emailAvailability:
            return "users/is-available"
        }
    }
}
