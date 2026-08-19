//
//  UserListView.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import SwiftUI
import Kingfisher

struct UserListView: View {
    @State private var viewModel = UserListViewModel(userService: UserService())
    @State private var hasLoaded = false
    @State private var formIntent: UserFormIntent?
    
    var body: some View {
        NavigationStack {
            content
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        formIntent = .create
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .refreshable { await viewModel.loadUsers() }
        .sheet(item: $formIntent) { intent in
            UserFormView(intent: intent)
                .environment(viewModel)
        }
        .task {
            guard !hasLoaded else { return }
            await viewModel.loadUsers()
            hasLoaded = true
        }
        .onAppear {
            AnalyticsManager.shared.trackScreen("Users")
        }
        .onDisappear {
            viewModel.cancelInFlightRequests()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.loadingState {
        case .idle, .loading:
            ProgressView()
        case .loaded(let users):
            List(users) { user in
                UserRowView(user: user)
                    .padding(.vertical, 6)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Edit") {
                            formIntent = .update(user)
                        }
                        .tint(.blue)
                    }
            }
            .listStyle(.plain)
        case .empty:
            Text("no users yet")
        case .error(let string):
            Text(string)
        }
    }
}

#Preview {
    UserListView()
}
