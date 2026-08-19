//
//  ProductService.swift
//  DemoApp
//
//  Created by Omkar Chougule on 03/05/26.
//

import Foundation

protocol ProductServiceProtocol {
    func fetchProducts(offset: Int, limit: Int, filter: ProductFilter) async throws -> [Product]
    func updateProduct(_ id: Int, payload: UpdateProductRequest) async throws -> Product
    func createProduct(_ payload: CreateProductRequest) async throws -> Product
    func deleteProduct(_ id: Int) async throws
}

struct ProductService: ProductServiceProtocol  {
    private let client: APIClient
    
    init() {
        self.client = APIClient(baseURL: URLConstants.baseURL)
    }
    
    func fetchProducts(offset: Int = 0, limit: Int = 10, filter: ProductFilter = ProductFilter()) async throws -> [Product] {
        var queryItems = filter.queryItems
        queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
        queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        
        let requestModel = APIRequest<[Product]>(
            method: .get,
            path: .products(.products),
            queryItems: queryItems
        )
        return try await client.execute(requestModel)
    }
    
    func createProduct(_ payload: CreateProductRequest) async throws -> Product {
        let requestModel = try APIRequest<Product>(method: .post, path: .products(.products), body: payload)
        return try await client.execute(requestModel)
    }
    
    func updateProduct(_ id: Int, payload: UpdateProductRequest) async throws -> Product {
        let requestModel = try APIRequest<Product>(method: .put, path: .products(.byId(id)), body: payload)
        return try await client.execute(requestModel)
    }
    
    func deleteProduct(_ id: Int) async throws {
        let requestModel = APIRequest<EmptyResponse>(method: .delete, path: .products(.byId(id))) 
        _ = try await client.execute(requestModel)
    }
}

struct MockProductService: ProductServiceProtocol  {
    func fetchProducts(offset: Int = 0, limit: Int = 10, filter: ProductFilter = ProductFilter()) async throws -> [Product] {
        let filteredProducts = Product.mockProducts.filter { product in
            matches(filter: filter, product: product)
        }
        return Array(filteredProducts.dropFirst(offset).prefix(limit))
    }
    
    func createProduct(_ payload: CreateProductRequest) async throws -> Product {
        return Product.mockProducts.first!
    }
    
    func updateProduct(_ id: Int, payload: UpdateProductRequest) async throws -> Product {
        return Product.mockProducts.first!
    }
    
    func deleteProduct(_ id: Int) async throws {
        ///
    }
    
    private func matches(filter: ProductFilter, product: Product) -> Bool {
        if !filter.title.isEmpty, !product.title.localizedCaseInsensitiveContains(filter.title) {
            return false
        }
        
        if let exactPrice = Int(filter.exactPrice), product.price != exactPrice {
            return false
        }
        
        if let minimumPrice = Int(filter.minimumPrice), product.price < minimumPrice {
            return false
        }
        
        if let maximumPrice = Int(filter.maximumPrice), product.price > maximumPrice {
            return false
        }
        
        if let categoryId = Int(filter.categoryId), product.category?.id != categoryId {
            return false
        }
        
        if !filter.categorySlug.isEmpty, product.category?.slug != filter.categorySlug {
            return false
        }
        
        return true
    }
}
