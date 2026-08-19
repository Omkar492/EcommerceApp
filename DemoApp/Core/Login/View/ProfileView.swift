//
//  ProfileView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 10/05/26.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if let user = viewModel.session?.user {
                    Section {
                        HStack(spacing: 16) {
                            avatar(urlString: user.avatar)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section {
                        LabeledContent("Role", value: user.role ?? "Unknown")
                        LabeledContent("User ID", value: "\(user.id)")
                    }
                }
                
                Section {
                    Button("Refresh Profile") {
                        Task { await viewModel.refreshProfile() }
                    }
                    .disabled(viewModel.isLoading)
                    
                    Button("Sign Out", role: .destructive) {
                        viewModel.signOut()
                    }
                }
                
                if case .error(let message) = viewModel.loadingState {
                    Section {
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                AnalyticsManager.shared.trackScreen("Profile")
            }
        }
    }
    
    @ViewBuilder
    private func avatar(urlString: String?) -> some View {
        if let urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ProfileView(viewModel: LoginViewModel(service: MockLoginService()))
}
