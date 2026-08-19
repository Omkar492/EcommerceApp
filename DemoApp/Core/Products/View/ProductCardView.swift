import Kingfisher
import SwiftUI

struct ProductCardView: View {
    let product: Product

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                ZStack {
                    failureView(cornerRadius: 14)

                    KFImage.url(URL(string: product.images.first ?? ""))
                        .placeholder {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.gray.opacity(0.12))

                                ProgressView()
                            }
                        }
                        .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 92, height: 92)))
                        .cacheOriginalImage()
                        .cancelOnDisappear(true)
                        .fade(duration: 0.2)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 92, height: 92)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                if let categoryName = product.category?.name {
                    Text(categoryName.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(product.title)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Text("$\(product.price)")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.blue)
                }

                Text(product.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func failureView(cornerRadius: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.gray.opacity(0.12))

            Image(systemName: "photo")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ProductCardView(product: Product.mockProducts.first!)
}
