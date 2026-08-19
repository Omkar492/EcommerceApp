//
//  ProductFilterView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 10/05/26.
//

import SwiftUI

struct ProductFilterView: View {
    @Bindable var viewModel: ProductsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Product") {
                    TextField("Title", text: $viewModel.draftFilter.title)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section("Price") {
                    TextField("Exact price", text: $viewModel.draftFilter.exactPrice)
                        .keyboardType(.numberPad)
                    
                    TextField("Minimum price", text: $viewModel.draftFilter.minimumPrice)
                        .keyboardType(.numberPad)
                    
                    TextField("Maximum price", text: $viewModel.draftFilter.maximumPrice)
                        .keyboardType(.numberPad)
                }
                
                Section("Category") {
                    TextField("Category ID", text: $viewModel.draftFilter.categoryId)
                        .keyboardType(.numberPad)
                    
                    TextField("Category slug", text: $viewModel.draftFilter.categorySlug)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("Filters")
            .onAppear {
                AnalyticsManager.shared.trackScreen("Product Filters")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear") {
                        Task {
                            await viewModel.clearFilters()
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.filter.isActive && !viewModel.draftFilter.isActive)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        Task {
                            await viewModel.applyDraftFilter()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProductFilterView(viewModel: ProductsViewModel(service: MockProductService()))
}
