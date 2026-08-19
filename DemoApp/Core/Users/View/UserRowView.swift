//
//  UserRowView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Kingfisher
import SwiftUI

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("\(user.id)")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(width: 34, alignment: .leading)

            avatar(for: user)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if let role = user.role, !role.isEmpty {
                roleBadge(role)
            }
        }
    }
    
    @ViewBuilder
    private func avatar(for user: User) -> some View {
        if let avatar = user.avatar, let url = URL(string: avatar) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 48, height: 48)
                }
                .cancelOnDisappear(true)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
        } else {
            Circle()
                .fill(Color(.secondarySystemFill))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundStyle(.secondary)
                )
        }
    }
    
    @ViewBuilder
    private func roleBadge(_ role: String) -> some View {
        let lowercasedRole = role.lowercased()
        let isAdmin = lowercasedRole == "admin"
        let isCustomer = lowercasedRole == "customer"

        let background: Color = isAdmin ? .purple.opacity(0.15) : (isCustomer ? .blue.opacity(0.15) : .gray.opacity(0.15))
        let foreground: Color = isAdmin ? .purple : (isCustomer ? .blue : .gray)

        Text(role.capitalized)
            .font(.caption.weight(.semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(background)
            .clipShape(Capsule())
    }
}

#Preview {
    UserRowView(user: User.mock)
}
