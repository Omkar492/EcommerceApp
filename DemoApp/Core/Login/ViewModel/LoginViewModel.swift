//
//  LoginViewModel.swift
//  DemoApp
//
//  Created by Omkar Chougule on 10/05/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class LoginViewModel {
    var email = "john@mail.com"
    var password = "changeme"
    var registrationName = ""
    var registrationEmail = ""
    var registrationPassword = ""
    var registrationAvatar = "https://picsum.photos/800"
    var registrationMessage: String?
    var isRegistrationEmailAvailable: Bool?
    var isCheckingRegistrationEmail = false
    var session: AuthSession?
    var loadingState: LoadingState<AuthSession> = .idle
    
    private let service: LoginServiceProtocol
    private let tokenStorageKey = "auth.tokens"
    
    var isAuthenticated: Bool {
        session != nil
    }
    
    var isLoading: Bool {
        if case .loading = loadingState {
            return true
        }
        return false
    }
    
    init(service: LoginServiceProtocol) {
        self.service = service
    }
    
    func login() async {
        loadingState = .loading
        AnalyticsManager.shared.track(.loginStarted, parameters: ["email": email])
        
        do {
            let tokens = try await service.login(email: email, password: password)
            let user = try await service.fetchProfile(accessToken: tokens.accessToken)
            let session = AuthSession(tokens: tokens, user: user)
            save(tokens)
            self.session = session
            loadingState = .loaded(session)
            AnalyticsManager.shared.track(.loginSucceeded, parameters: ["user_id": user.id])
        } catch {
            loadingState = .error(error.localizedDescription)
            AnalyticsManager.shared.track(.loginFailed, parameters: ["message": error.localizedDescription])
        }
    }
    
    func register() async {
        loadingState = .loading
        registrationMessage = nil
        AnalyticsManager.shared.track(.registrationStarted, parameters: ["email": registrationEmail])
        
        do {
            let payload = CreateUserRequest(
                name: registrationName,
                email: registrationEmail,
                password: registrationPassword,
                avatar: registrationAvatar
            )
            _ = try await service.register(payload: payload)
            email = registrationEmail
            password = registrationPassword
            let tokens = try await service.login(email: registrationEmail, password: registrationPassword)
            let user = try await service.fetchProfile(accessToken: tokens.accessToken)
            let session = AuthSession(tokens: tokens, user: user)
            save(tokens)
            self.session = session
            loadingState = .loaded(session)
            AnalyticsManager.shared.track(.registrationSucceeded, parameters: ["user_id": user.id])
        } catch {
            loadingState = .error(error.localizedDescription)
            AnalyticsManager.shared.track(.registrationFailed, parameters: ["message": error.localizedDescription])
        }
    }
    
    func checkRegistrationEmailAvailability() async {
        guard !registrationEmail.isEmpty else { return }
        
        isCheckingRegistrationEmail = true
        registrationMessage = nil
        defer { isCheckingRegistrationEmail = false }
        
        do {
            let isAvailable = try await service.checkEmailAvailability(email: registrationEmail)
            isRegistrationEmailAvailable = isAvailable
            registrationMessage = isAvailable ? "Email is already registered" : "Email is available"
            AnalyticsManager.shared.track(
                .emailAvailabilityChecked,
                parameters: ["is_available": isAvailable]
            )
        } catch {
            isRegistrationEmailAvailable = nil
            registrationMessage = error.localizedDescription
            AnalyticsManager.shared.track(
                .emailAvailabilityChecked,
                parameters: ["message": error.localizedDescription]
            )
        }
    }
    
    func restoreSession() async {
        guard session == nil, let tokens = savedTokens() else { return }
        
        loadingState = .loading
        
        do {
            let user = try await fetchProfileRefreshingTokenIfNeeded(tokens: tokens)
            guard let updatedTokens = savedTokens() else { return }
            let session = AuthSession(tokens: updatedTokens, user: user)
            self.session = session
            loadingState = .loaded(session)
            AnalyticsManager.shared.track(.sessionRestored, parameters: ["user_id": user.id])
        } catch {
            AnalyticsManager.shared.track(.sessionRestoreFailed, parameters: ["message": error.localizedDescription])
            signOut()
        }
    }
    
    func refreshProfile() async {
        guard let session else { return }
        
        loadingState = .loading
        
        do {
            let user = try await fetchProfileRefreshingTokenIfNeeded(tokens: session.tokens)
            guard let updatedTokens = savedTokens() else { return }
            let updatedSession = AuthSession(tokens: updatedTokens, user: user)
            self.session = updatedSession
            loadingState = .loaded(updatedSession)
            AnalyticsManager.shared.track(.profileRefreshed, parameters: ["user_id": user.id])
        } catch {
            loadingState = .error(error.localizedDescription)
            AnalyticsManager.shared.track(.profileRefreshFailed, parameters: ["message": error.localizedDescription])
        }
    }
    
    func signOut() {
        let userId = session?.user.id
        UserDefaults.standard.removeObject(forKey: tokenStorageKey)
        session = nil
        loadingState = .idle
        AnalyticsManager.shared.track(.signedOut, parameters: ["user_id": userId as Any])
    }
    
    private func fetchProfileRefreshingTokenIfNeeded(tokens: AuthTokens) async throws -> User {
        do {
            save(tokens)
            return try await service.fetchProfile(accessToken: tokens.accessToken)
        } catch let error as NetworkError where error.statusCode == 401 {
            let refreshedTokens = try await service.refreshTokens(refreshToken: tokens.refreshToken)
            save(refreshedTokens)
            return try await service.fetchProfile(accessToken: refreshedTokens.accessToken)
        }
    }
    
    private func save(_ tokens: AuthTokens) {
        guard let data = try? JSONEncoder().encode(tokens) else { return }
        UserDefaults.standard.set(data, forKey: tokenStorageKey)
    }
    
    private func savedTokens() -> AuthTokens? {
        guard let data = UserDefaults.standard.data(forKey: tokenStorageKey) else { return nil }
        return try? JSONDecoder().decode(AuthTokens.self, from: data)
    }
}
