//
//  APIRoutes.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

nonisolated struct URLConstants {
    static let baseURL = URL(string: "https://api.escuelajs.co/api/v1/")!
}

nonisolated enum APIRoutes {
    case auth(AuthEndpointPath)
    case products(ProductsEndpointPath)
    case users(UsersEndpointPath)
    
    var path: String {
        switch self {
        case .auth(let authRoute):
            return authRoute.path
        case .products(let productRoute):
            return productRoute.path
        case .users(let userRoute):
            return userRoute.path
        }
    }
}
