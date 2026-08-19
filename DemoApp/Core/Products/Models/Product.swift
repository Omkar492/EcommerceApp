//
//  Product.swift
//  DemoApp
//
//  Created by Omkar Chougule on 03/05/26.
//

import Foundation

struct Product: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let slug: String?
    let price: Int
    let description: String
    let images: [String]
    let category: Category?
    let creationAt: String?
    let updatedAt: String?
    
    struct Category: Codable, Identifiable, Hashable {
        let id: Int
        let name: String
        let slug: String?
        let image: String?
        let creationAt: String?
        let updatedAt: String?
    }
}

extension Product {
    static let mockProducts: [Product] = [
        Product(
            id: 1,
            title: "Minimal Desk Lamp",
            slug: "minimal-desk-lamp",
            price: 48,
            description: "Warm light desk lamp with adjustable arm and matte finish.",
            images: ["https://picsum.photos/seed/lamp/600/400"],
            category: .init(
                id: 10,
                name: "Home",
                slug: "home",
                image: "https://picsum.photos/seed/home/300/300",
                creationAt: nil,
                updatedAt: nil
            ),
            creationAt: nil,
            updatedAt: nil
        ),
        Product(
            id: 2,
            title: "Canvas Backpack",
            slug: "canvas-backpack",
            price: 79,
            description: "Everyday backpack with laptop sleeve and water-resistant canvas.",
            images: ["https://picsum.photos/seed/bag/600/400"],
            category: .init(
                id: 2,
                name: "Accessories",
                slug: "accessories",
                image: "https://picsum.photos/seed/accessories/300/300",
                creationAt: nil,
                updatedAt: nil
            ),
            creationAt: nil,
            updatedAt: nil
        ),
        Product(
            id: 3,
            title: "Training Sneakers",
            slug: "training-sneakers",
            price: 120,
            description: "Lightweight trainers designed for daily workouts and walking.",
            images: ["https://picsum.photos/seed/shoes/600/400"],
            category: .init(
                id: 4,
                name: "Shoes",
                slug: "shoes",
                image: "https://picsum.photos/seed/shoescat/300/300",
                creationAt: nil,
                updatedAt: nil
            ),
            creationAt: nil,
            updatedAt: nil
        ),
        Product(
            id: 4,
            title: "Stoneware Mug Set",
            slug: "stoneware-mug-set",
            price: 34,
            description: "Set of four stackable mugs with speckled glaze finish.",
            images: ["https://picsum.photos/seed/mugs/600/400"],
            category: .init(
                id: 10,
                name: "Home",
                slug: "home",
                image: "https://picsum.photos/seed/home2/300/300",
                creationAt: nil,
                updatedAt: nil
            ),
            creationAt: nil,
            updatedAt: nil
        )
    ]
}
