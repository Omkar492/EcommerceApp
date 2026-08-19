//
//  UserListViewModel.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//


import Foundation
import Observation


@Observable
final class UserListViewModel: @MainActor ListMutating {
    var loadingState: LoadingState<[User]> = .idle
    
    let userService: UserServiceProtocol
    private let loadCancellationToken = CancellationToken()

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }

    deinit {
        cancelInFlightRequests()
    }

    func loadUsers() async {
        await runCancellableRequest { [weak self] in
            await self?.performLoadUsers()
        }
    }

    func cancelInFlightRequests() {
        loadCancellationToken.cancel()
    }

    private func performLoadUsers() async {
        loadingState = .loading
        do {
            let users = try await userService.fetchUsers()
            try Task.checkCancellation()
            loadingState = users.isEmpty ? .empty : .loaded(users)
        } catch is CancellationError {
            loadingState = .idle
        } catch {
            print("failed to fetch users \(error.localizedDescription)")
        }
    }

    func createUser(_ payload: CreateUserRequest) async {
        do {
            let newUser = try await userService.createUser(payload: payload)
            insertOrStart(with: newUser)
        } catch {
            print("failed to create user \(error.localizedDescription)")
        }
    }

    func updateUser(id: Int, payload: UpdateUserRequest) async {
        do {
            let updatedUser = try await userService.updateUser(id, payload: payload)
            replaceItemIfLoaded(updatedUser)
        } catch {
            print("failed to update user \(error.localizedDescription)")
        }
    }

    private func runCancellableRequest(operation: @escaping @MainActor () async -> Void) async {
        loadCancellationToken.cancel()
        let task = Task { @MainActor in
            await operation()
        }
        loadCancellationToken.register(task)
        await task.value
    }
}
