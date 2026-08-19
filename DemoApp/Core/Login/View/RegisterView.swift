//
//  RegisterView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 10/05/26.
//

import SwiftUI

struct RegisterView: View {
    @Bindable var viewModel: LoginViewModel
    
    private var canRegister: Bool {
        !viewModel.registrationName.isEmpty &&
        !viewModel.registrationEmail.isEmpty &&
        !viewModel.registrationPassword.isEmpty &&
        !viewModel.registrationAvatar.isEmpty &&
        viewModel.isRegistrationEmailAvailable != true &&
        !viewModel.isLoading
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $viewModel.registrationName)
                    .textInputAutocapitalization(.words)
                
                TextField("Email", text: $viewModel.registrationEmail)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.registrationEmail) {
                        Task { await viewModel.checkRegistrationEmailAvailability() }
                    }
                
                SecureField("Password", text: $viewModel.registrationPassword)
                
                TextField("Avatar URL", text: $viewModel.registrationAvatar)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .autocorrectionDisabled()
            }
            
            Section {
                Button {
                    Task { await viewModel.checkRegistrationEmailAvailability() }
                } label: {
                    if viewModel.isCheckingRegistrationEmail {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Check Email Availability")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(viewModel.registrationEmail.isEmpty || viewModel.isCheckingRegistrationEmail)
                
                Button {
                    Task { await viewModel.register() }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(!canRegister)
            }
            
            if let registrationMessage = viewModel.registrationMessage {
                Section {
                    Text(registrationMessage)
                        .foregroundStyle(viewModel.isRegistrationEmailAvailable == true ? .red : .secondary)
                }
            }
            
            if case .error(let message) = viewModel.loadingState {
                Section {
                    Text(message)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Create Account")
        .onAppear {
            AnalyticsManager.shared.trackScreen("Create Account")
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(viewModel: LoginViewModel(service: MockLoginService()))
    }
}
