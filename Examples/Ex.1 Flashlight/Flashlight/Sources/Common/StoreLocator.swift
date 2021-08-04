//
//  StoreLocator.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import Foundation
import ReduxCore

final class StoreLocator {
    private static var store: Store<State>?
    
    static func populate(with store: Store<State>) {
        self.store = store
    }
    
    static var shared: Store<State> {
        guard let store = store else {
            fatalError("Store is not populated into locator")
        }
        
        return store
    }
}
