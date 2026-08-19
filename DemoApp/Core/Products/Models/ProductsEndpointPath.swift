//
//  ProductsEndpointPath.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

nonisolated enum ProductsEndpointPath {
    case products
    case byId(Int)
    
    var path: String {
        switch self {
        case .products:
            return "products"
        case .byId(let id):
            return "products/\(id)"
        }
    }
}
