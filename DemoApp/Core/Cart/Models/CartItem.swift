//
//  CartItem.swift
//  DemoApp
//
//  Created by Omkar Chougule on 24/05/26.
//

import Foundation

struct CartItem: Identifiable, Hashable {
    let product: Product
    var quantity: Int
    
    var id: Int {
        product.id
    }
    
    var subtotal: Int {
        product.price * quantity
    }
}
