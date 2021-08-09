//
//  Cancellation.swift
//  ReduxCore
//
//  Copyright © 2021 Betterme. All rights reserved.
//  Created by Maksym Husar  on 05.08.2021.
//

import Foundation

/// A type-erasing cancellable object that executes a provided closure when canceled.
///
/// ``Store/observe(with:)``  implementation can use this type to provide a “cancellation token” that makes it possible for a caller to cancel observation.
///
/// A ``Cancellation`` instance automatically calls ``cancel()`` when deinitialized, unless called manually.
public final class Cancellation {
    private var isCanceled: Bool = false
    private let cancelAction: () -> Void
    
    /// Initializes the cancellable object with the given cancel-time closure.
    ///
    /// - Parameter cancel: A closure that the `cancel()` method executes.
    ///
    /// - Note: Instance cannot be created outside the module
    init(_ cancel: @escaping () -> Void) {
        self.cancelAction = cancel
    }
    
    /// Cancel the activity
    public func cancel() {
        isCanceled = true
        cancelAction()
    }
    
    deinit {
        guard isCanceled == false else { return }
        cancelAction()
    }
}

/// Allows Cancellation instances to be compared and stored in sets and dicts.
/// Uses `ObjectIdentifier` to distinguish between instances
extension Cancellation: Hashable {
    public static func ==(lhs: Cancellation, rhs: Cancellation) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
