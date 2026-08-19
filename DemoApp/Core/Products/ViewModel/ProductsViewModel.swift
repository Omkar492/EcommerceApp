//
//  ProductsViewModel.swift
//  DemoApp
//
//  Created by Omkar Chougule on 03/05/26.
//

import Foundation

@Observable
final class ProductsViewModel: @MainActor ListMutating {
    var products: [Product] = []
    
    var loadingState: LoadingState<[Product]> = .idle
    var mutationState: MutationState = .idle
    var isLoadingNextPage = false
    var canLoadMorePages = true
    var searchText = ""
    var filter = ProductFilter()
    var draftFilter = ProductFilter()
    
    private let service: ProductServiceProtocol
    private let pageSize = 10
    private let loadCancellationToken = CancellationToken()
    private let nextPageCancellationToken = CancellationToken()
    
    var visibleProducts: [Product] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return products }
        
        return products.filter { product in
            product.title.localizedCaseInsensitiveContains(query) ||
            product.description.localizedCaseInsensitiveContains(query) ||
            product.category?.name.localizedCaseInsensitiveContains(query) == true ||
            "\(product.price)".contains(query)
        }
    }
    
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isFiltering: Bool {
        filter.isActive
    }
    
    init(service: ProductServiceProtocol) {
        self.service = service
    }

    deinit {
        cancelInFlightRequests()
    }
    
    func loadProducts() async {
        await runCancellableRequest(with: loadCancellationToken) { [weak self] in
            await self?.performLoadProducts()
        }
    }

    func cancelInFlightRequests() {
        loadCancellationToken.cancel()
        nextPageCancellationToken.cancel()
    }

    private func performLoadProducts() async {
        loadingState = .loading
        products = []
        canLoadMorePages = true

        do {
            let products = try await service.fetchProducts(offset: 0, limit: pageSize, filter: filter)
            try Task.checkCancellation()
            self.products = products
            canLoadMorePages = products.count == pageSize
            loadingState = products.isEmpty ? .empty : .loaded(products)
            AnalyticsManager.shared.track(
                .productsLoaded,
                parameters: [
                    "count": products.count,
                    "has_filters": filter.isActive
                ]
            )
        } catch is CancellationError {
            loadingState = products.isEmpty ? .idle : .loaded(products)
        } catch {
            loadingState = .error(error.localizedDescription)
            AnalyticsManager.shared.track(.productsLoadFailed, parameters: ["message": error.localizedDescription])
        }
    }
    
    func loadNextPageIfNeeded(currentProduct product: Product) async {
        guard shouldLoadNextPage(for: product) else { return }

        await runCancellableRequest(with: nextPageCancellationToken) { [weak self] in
            await self?.performLoadNextPage()
        }
    }

    private func performLoadNextPage() async {
        guard !isLoadingNextPage else { return }
        
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }
        
        do {
            let offset = products.count
            let newProducts = try await service.fetchProducts(offset: products.count, limit: pageSize, filter: filter)
            try Task.checkCancellation()
            canLoadMorePages = newProducts.count == pageSize
            products.append(contentsOf: newProducts)
            loadingState = products.isEmpty ? .empty : .loaded(products)
            AnalyticsManager.shared.track(
                .productsNextPageLoaded,
                parameters: [
                    "count": newProducts.count,
                    "offset": offset,
                    "has_filters": filter.isActive
                ]
            )
        } catch is CancellationError {
            return
        } catch {
            loadingState = .error(error.localizedDescription)
            AnalyticsManager.shared.track(.productsNextPageFailed, parameters: ["message": error.localizedDescription])
        }
    }
    
    func createProduct(_ payload: CreateProductRequest) async {
        mutationState = .inProgress(.create)

        do {
            let newProduct = try await service.createProduct(payload)
            insertOrStart(with: newProduct)
            syncProductsFromLoadingState()
            mutationState = .success(.create)
            AnalyticsManager.shared.track(.productCreated, parameters: ["product_id": newProduct.id])
        } catch {
            mutationState = .failure(.create, error.localizedDescription)
            AnalyticsManager.shared.track(.productCreateFailed, parameters: ["message": error.localizedDescription])
        }
    }
    
    func updateProduct(_ product: Product, with payload: UpdateProductRequest) async {
        mutationState = .inProgress(.update)
        do {
            let newProduct = try await service.updateProduct(product.id, payload: payload)
            replaceItemIfLoaded(newProduct)
            syncProductsFromLoadingState()
            mutationState = .success(.update)
            AnalyticsManager.shared.track(.productUpdated, parameters: ["product_id": newProduct.id])
        } catch {
            mutationState = .failure(.update, error.localizedDescription)
            AnalyticsManager.shared.track(.productUpdateFailed, parameters: ["message": error.localizedDescription])
        }
    }
    
    func deleteProduct(_ id: Int) async {
        mutationState = .inProgress(.delete)
        do {
            try await service.deleteProduct(id)
            removeItemIfLoaded(withId: id)
            syncProductsFromLoadingState()
            mutationState = .success(.update)
            AnalyticsManager.shared.track(.productDeleted, parameters: ["product_id": id])
        } catch {
            mutationState = .failure(.update, error.localizedDescription)
            AnalyticsManager.shared.track(.productDeleteFailed, parameters: ["message": error.localizedDescription])
        }
    }
    
    func resetMutationState() {
        self.mutationState = .idle
    }
    
    func prepareDraftFilter() {
        draftFilter = filter
    }
    
    func applyDraftFilter() async {
        filter = draftFilter
        searchText = ""
        AnalyticsManager.shared.track(
            .productFiltersApplied,
            parameters: [
                "title": filter.title,
                "exact_price": filter.exactPrice,
                "minimum_price": filter.minimumPrice,
                "maximum_price": filter.maximumPrice,
                "category_id": filter.categoryId,
                "category_slug": filter.categorySlug
            ]
        )
        await loadProducts()
    }
    
    func clearFilters() async {
        filter = ProductFilter()
        draftFilter = ProductFilter()
        AnalyticsManager.shared.track(.productFiltersCleared)
        await loadProducts()
    }
    
    func submitSearch() {
        AnalyticsManager.shared.track(
            .productSearchSubmitted,
            parameters: [
                "query": searchText,
                "result_count": visibleProducts.count
            ]
        )
    }
    
    private func shouldLoadNextPage(for product: Product) -> Bool {
        guard canLoadMorePages, !isLoadingNextPage, !isSearching else { return false }
        guard let thresholdIndex = products.index(products.endIndex, offsetBy: -3, limitedBy: products.startIndex) else {
            return products.last == product
        }
        return products[thresholdIndex].id == product.id
    }
    
    private func syncProductsFromLoadingState() {
        guard case .loaded(let products) = loadingState else { return }
        self.products = products
    }

    private func runCancellableRequest(
        with token: CancellationToken,
        operation: @escaping @MainActor () async -> Void
    ) async {
        token.cancel()
        let task = Task { @MainActor in
            await operation()
        }
        token.register(task)
        await task.value
    }
}
