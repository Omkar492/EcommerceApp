//
//  ProductsView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 03/05/26.
//

import SwiftUI

struct ProductsView: View {
    @State private var viewModel = ProductsViewModel(service: ProductService())
    @Environment(CartViewModel.self) private var cartViewModel
    @State private var isShowingCreateSheet = false
    @State private var isShowingFilterSheet = false
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .idle, .loading:
                    ProgressView()
                case .loaded:
                    productList
                case .empty:
                    Text("No products to display")
                case .error(let errorMessage):
                    Text(errorMessage)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search products")
            .onSubmit(of: .search) {
                viewModel.submitSearch()
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.prepareDraftFilter()
                        isShowingFilterSheet = true
                    } label: {
                        Image(systemName: viewModel.isFiltering ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingCreateSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
                    .environment(viewModel)
                    .environment(cartViewModel)
            }
            .navigationDestination(for: CartDestination.self) { destination in
                switch destination {
                case .review:
                    CartReviewView()
                        .environment(cartViewModel)
                }
            }
            .sheet(isPresented: $isShowingCreateSheet, content: {
                ProductFormView(intent: .create)
                    .environment(viewModel)
            })
            .sheet(isPresented: $isShowingFilterSheet, content: {
                ProductFilterView(viewModel: viewModel)
            })
            .refreshable { await viewModel.loadProducts() }
            .task { await viewModel.loadProducts() }
            .onAppear {
                AnalyticsManager.shared.trackScreen("Products")
            }
            .onDisappear {
                viewModel.cancelInFlightRequests()
            }
        }
    }
    
    @ViewBuilder
    private var productList: some View {
        if viewModel.visibleProducts.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.visibleProducts) { product in
                        NavigationLink(value: product) {
                            ProductCardView(product: product)
                        }
                        .buttonStyle(.plain)
                        .task {
                            await viewModel.loadNextPageIfNeeded(currentProduct: product)
                        }
                    }
                    
                    if viewModel.isLoadingNextPage {
                        ProgressView()
                            .padding(.vertical)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ProductsView()
        .environment(CartViewModel())
}
