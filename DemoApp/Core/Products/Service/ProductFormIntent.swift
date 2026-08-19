//
//  ProductFormIntent.swift
//  DemoApp
//
//  Created by Omkar Chougule on 03/05/26.
//


import Foundation

enum ProductFormIntent {
    case create
    case update(Product)

    var navigationTitle: String {
        switch self {
        case .create:
            return "New Product"
        case .update:
            return "Edit Product"
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
}
