//
//  LoadingState.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

enum LoadingState<Value: Decodable> {
    case idle
    case loading
    case loaded(Value)
    case empty
    case error(String)
}
