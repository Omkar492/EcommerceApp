//
//  UserFormIntent.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//


import Foundation

enum UserFormIntent: Identifiable {
    case create
    case update(User)

    var navigationTitle: String {
        switch self {
        case .create:
            return "New User"
        case .update:
            return "Edit User"
        }
    }

    var submitTitle: String {
        switch self {
        case .create:
            return "Create"
        case .update:
            return "Save"
        }
    }
    
    var id: Int {
        switch self {
        case .create:
            return 0
        case .update(let user):
            return user.id
        }
    }
}
