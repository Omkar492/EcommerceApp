//
//  CartViewModel.swift
//  DemoApp
//
//  Created by Omkar Chougule on 24/05/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class CartViewModel {
    var items: [CartItem] = []
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalAmount: Int {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    var hasItems: Bool {
        !items.isEmpty
    }
    
    func quantity(for product: Product) -> Int {
        items.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }
    
    func add(_ product: Product, quantity: Int = 1) {
        let quantityToAdd = max(quantity, 1)
        
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantityToAdd
        } else {
            items.append(CartItem(product: product, quantity: quantityToAdd))
        }
        
        AnalyticsManager.shared.track(
            .cartProductAdded,
            parameters: [
                "product_id": product.id,
                "quantity": quantityToAdd,
                "cart_count": itemCount
            ]
        )
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }
        
        let updatedQuantity = max(quantity, 1)
        items[index].quantity = updatedQuantity
        
        AnalyticsManager.shared.track(
            .cartProductQuantityUpdated,
            parameters: [
                "product_id": product.id,
                "quantity": updatedQuantity,
                "cart_count": itemCount
            ]
        )
    }
    
    func remove(_ product: Product) {
        items.removeAll { $0.product.id == product.id }
        
        AnalyticsManager.shared.track(
            .cartProductRemoved,
            parameters: [
                "product_id": product.id,
                "cart_count": itemCount
            ]
        )
    }
    
    func placeOrder() {
        AnalyticsManager.shared.track(
            .cartOrderPlaced,
            parameters: [
                "item_count": itemCount,
                "total_amount": totalAmount
            ]
        )
    }
    
    func clear() {
        items = []
    }
}
