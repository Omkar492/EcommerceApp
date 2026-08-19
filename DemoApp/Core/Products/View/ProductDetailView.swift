import Kingfisher
import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State private var isShowingEditForm = false
    @State private var selectedQuantity = 1
    @Environment(ProductsViewModel.self) private var viewModel
    @Environment(CartViewModel.self) private var cartViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ZStack {
                    failureView

                    KFImage.url(URL(string: product.images.first ?? ""))
                        .placeholder {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.gray.opacity(0.12))
                                .overlay(ProgressView())
                        }
                        .cacheOriginalImage()
                        .cancelOnDisappear(true)
                        .fade(duration: 0.2)
                        .resizable()
                        .scaledToFill()
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 10) {
                    Text(product.title)
                        .font(.title2.bold())

                    Text("$\(product.price)")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.blue)

                    if let categoryName = product.category?.name {
                        Label(categoryName, systemImage: "tag")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text(product.description)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                
                VStack(spacing: 12) {
                    Stepper(value: $selectedQuantity, in: 1...99) {
                        HStack {
                            Text("Quantity")
                            Spacer()
                            Text("\(selectedQuantity)")
                                .fontWeight(.semibold)
                        }
                    }
                    
                    if cartViewModel.quantity(for: product) > 0 {
                        Text("In cart: \(cartViewModel.quantity(for: product))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(14)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                
                Button {
                    cartViewModel.add(product, quantity: selectedQuantity)
                } label: {
                    Label("Add Cart", systemImage: "cart.badge.plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                NavigationLink(value: CartDestination.review) {
                    Text("Buy Now")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .simultaneousGesture(
                    TapGesture().onEnded {
                        cartViewModel.add(product, quantity: selectedQuantity)
                        AnalyticsManager.shared.track(.cartCheckoutTapped, parameters: ["cart_count": cartViewModel.itemCount])
                    }
                )
            }
            .padding(16)
        }
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            AnalyticsManager.shared.trackScreen("Product Detail")
        }
        .sheet(isPresented: $isShowingEditForm, content: {
            ProductFormView(intent: .update(product))
                .environment(viewModel)
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isShowingEditForm = true
                }
            }
        }
    }

    private var failureView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.gray.opacity(0.12))
            .overlay(
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            )
    }
}


#Preview {
    ProductDetailView(product: Product.mockProducts.first!)
        .environment(ProductsViewModel(service: MockProductService()))
        .environment(CartViewModel())
}
