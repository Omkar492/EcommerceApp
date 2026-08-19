//
//  ContentView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 03/05/26.
//

import SwiftUI

struct ContentView: View {
    @State private var loginViewModel = LoginViewModel(service: LoginService())
    @State private var cartViewModel = CartViewModel()
    
    var body: some View {
        Group {
            if loginViewModel.isAuthenticated {
                TabView {
                    Tab("Products", systemImage: "cart") {
                        ProductsView()
                            .environment(cartViewModel)
                    }
                    
                    Tab("Cart", systemImage: "bag") {
                        NavigationStack {
                            CartReviewView()
                                .environment(cartViewModel)
                        }
                    }
                    .badge(cartViewModel.itemCount)
                    
                    Tab("Users", systemImage: "person") {
                        UserListView()
                    }
                    
                    Tab("Profile", systemImage: "person.crop.circle") {
                        ProfileView(viewModel: loginViewModel)
                    }
                }
            } else {
                LoginView(viewModel: loginViewModel)
            }
        }
        .task {
            await loginViewModel.restoreSession()
        }
    }
}

#Preview {
    ContentView()
}
