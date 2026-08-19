//
//  ProductPayloads.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

struct CreateProductRequest: Encodable {
    let title: String
    let price: Int
    let description: String
    let categoryId: Int
    let images: [String]
}

struct UpdateProductRequest: Encodable {
    let title: String
    let price: Int
}
