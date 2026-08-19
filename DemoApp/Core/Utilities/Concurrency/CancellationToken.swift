//
//  CancellationToken.swift
//  DemoApp
//
//  Created by Codex on 24/05/26.
//

import Foundation

final class CancellationToken {
    private var task: Task<Void, Never>?

    func register(_ task: Task<Void, Never>) {
        self.task = task
    }

    func cancel() {
        task?.cancel()
        task = nil
    }

    deinit {
        cancel()
    }
}
