//
//  CartReviewView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 24/05/26.
//

import SwiftUI

struct CartReviewView: View {
    @Environment(CartViewModel.self) private var cartViewModel
    @State private var isShowingOrderAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if cartViewModel.items.isEmpty {
                    ContentUnavailableView("Cart is empty", systemImage: "cart")
                } else {
                    VStack(spacing: 12) {
                        ForEach(cartViewModel.items) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                ProductCardView(product: item.product)
                                
                                Stepper(
                                    value: Binding(
                                        get: { item.quantity },
                                        set: { newQuantity in
                                            cartViewModel.updateQuantity(for: item.product, quantity: newQuantity)
                                        }
                                    ),
                                    in: 1...99
                                ) {
                                    HStack {
                                        Text("Quantity")
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text("\(item.quantity)")
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                HStack {
                                    Text("Subtotal")
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text("$\(item.subtotal)")
                                        .fontWeight(.semibold)
                                }
                                
                                Button(role: .destructive) {
                                    cartViewModel.remove(item.product)
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                    
                    VStack(spacing: 12) {
                        LabeledContent("Items", value: "\(cartViewModel.itemCount)")
                        LabeledContent("Total", value: "$\(cartViewModel.totalAmount)")
                            .font(.headline)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                    
                    Button {
                        cartViewModel.placeOrder()
                        isShowingOrderAlert = true
                    } label: {
                        Text("Order")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .padding(16)
        }
        .navigationTitle("Review Cart")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            AnalyticsManager.shared.trackScreen("Cart Review")
        }
        .alert("Done transaction", isPresented: $isShowingOrderAlert) {
            Button("OK") {
                cartViewModel.clear()
            }
        } message: {
            Text("Your order has been placed.")
        }
    }
}

#Preview {
    let cartViewModel = CartViewModel()
    cartViewModel.add(Product.mockProducts.first!)
    
    return NavigationStack {
        CartReviewView()
            .environment(cartViewModel)
    }
}
