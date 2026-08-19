//
//  ProductFilter.swift
//  DemoApp
//
//  Created by Omkar Chougule on 10/05/26.
//

import Foundation

nonisolated struct ProductFilter: Equatable {
    var title = ""
    var exactPrice = ""
    var minimumPrice = ""
    var maximumPrice = ""
    var categoryId = ""
    var categorySlug = ""
    
    var isActive: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !exactPrice.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !minimumPrice.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !maximumPrice.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !categoryId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !categorySlug.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        appendTrimmedValue(title, name: "title", to: &items)
        appendTrimmedValue(exactPrice, name: "price", to: &items)
        appendTrimmedValue(minimumPrice, name: "price_min", to: &items)
        appendTrimmedValue(maximumPrice, name: "price_max", to: &items)
        appendTrimmedValue(categoryId, name: "categoryId", to: &items)
        appendTrimmedValue(categorySlug, name: "categorySlug", to: &items)
        
        return items
    }
    
    private func appendTrimmedValue(_ value: String, name: String, to items: inout [URLQueryItem]) {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else { return }
        items.append(URLQueryItem(name: name, value: trimmedValue))
    }
}
