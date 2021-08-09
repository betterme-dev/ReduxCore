//
//  Subscription.swift
//  ReduxCore
//
//  Copyright © 2021 Betterme. All rights reserved.
//  Created by Maksym Husar  on 05.08.2021.
//

import Foundation

/// Internal wrapper for State observation closure
final class Subscription<State> {
    private let action: (State) -> Void
    
    init(_ action: @escaping (State) -> Void) {
        self.action = action
    }
    
    func update(with state: State) {
        action(state)
    }
}

/// Allows Subscription to be compared and stored in sets and dicts.
/// Uses `ObjectIdentifier` to distinguish between subscribers
extension Subscription: Hashable {
    public static func ==(lhs: Subscription, rhs: Subscription) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
