//
//  ListMutating.swift
//  DemoApp
//
//  Created by Omkar Chougule on 04/05/26.
//

import Foundation

protocol ListMutating: AnyObject {
    associatedtype Item: Identifiable & Decodable
    
    var loadingState: LoadingState<[Item]> { get set }
}

extension ListMutating {
    func insertOrStart(with item: Item) {
        switch loadingState {
        case .loaded(var items):
            items.insert(item, at: 0)
            loadingState = .loaded(items)
        default:
            loadingState = .loaded([item])
        }
    }
    
    func replaceItemIfLoaded(_ item: Item) {
        guard case .loaded(var items) = loadingState else { return }
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        items[index] = item
        loadingState = .loaded(items)
    }
    
    func removeItemIfLoaded(withId id: Int) {
        guard case .loaded(var items) = loadingState else { return }
        guard let index = items.firstIndex(where: { $0.id as! Int == id }) else {
            return
        }
        items.remove(at: index)
        loadingState = .loaded(items)
    }
}
