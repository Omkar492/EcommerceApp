//
//  LoginView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 10/05/26.
//

import SwiftUI

struct LoginView: View {
    @Bindable var viewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $viewModel.password)
                }
                
                Section {
                    Button {
                        Task { await viewModel.login() }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Log In")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty)
                    
                    NavigationLink("Create Account") {
                        RegisterView(viewModel: viewModel)
                    }
                }
                
                if case .error(let message) = viewModel.loadingState {
                    Section {
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Login")
            .onAppear {
                AnalyticsManager.shared.trackScreen("Login")
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(service: MockLoginService()))
}
