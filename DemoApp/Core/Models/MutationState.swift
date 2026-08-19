//
//  MutationState.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

enum MutationState {
    case idle
    case inProgress(MutationOperation)
    case success(MutationOperation)
    case failure(MutationOperation, String)
}

enum MutationOperation {
    case create
    case update
    case delete
}
