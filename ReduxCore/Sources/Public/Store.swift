//
//  Store.swift
//  ReduxCore
//
//  Copyright © 2021 Betterme. All rights reserved.
//

import Foundation

public typealias Dispatch = (Action) -> Void
public typealias Middleware<State> = (@escaping Dispatch, Action, State, State) -> Void

/// Reducer is a rule to proceed from current state to a new one
public typealias Reducer<State> = (State, Action) -> State

/// Store is a single mutation point of our app state.
public final class Store<State> {
    /// Store has its own queue, where all accesses and mutations are performed
    private let queue = DispatchQueue(label: "store private queue")
    private let subscriptionLock = UnfairLock()
    
    /// Current app state is stored here
    public private(set) var state: State
    
    private let reducer: Reducer<State>
    
    private var dispatch: Dispatch?
    
    /// Store should notify everyone about state changes
    private var subscribers: Set<Subscription<State>> = []
    
    private let middlewares: [Middleware<State>]
    
    public init(
        state: State,
        reducer: @escaping Reducer<State>,
        middlewares: [Middleware<State>]
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
        
        self.dispatch = { action in
            let oldState = self.state
            let newState = self.reducer(self.state, action)
            self.state = newState
            self.middlewares.forEach { middleware in
                middleware(self.dispatch, action, oldState, newState)
            }
            self.subscriptionLock.lock()
            self.subscribers.forEach { $0.update(with: newState) }
            self.subscriptionLock.unlock()
        }
    }
    
    /// Dispatch is async by nature.
    public func dispatch(action: Action) {
        queue.async {
            self.dispatch?(action)
        }
    }
    
    /// Attaches the specified action to the state updates.
    ///
    /// - Parameter action: The action to attach to watch for state updates.
    /// - Returns: A `Cancellation` instance that makes it possible for a caller to cancel observation.
    public func observe(with action: @escaping (State) -> Void) -> Cancellation {
        let subscription = Subscription(action)
        subscriptionLock.lock()
        subscribers.insert(subscription)
        subscriptionLock.unlock()
        subscription.update(with: state)
        
        /// Cancellation object should not keep a reference to subscription, so we need to use `weak` here
        let endObserving = Cancellation { [weak self, weak subscription] in
            guard let self = self, let subscription = subscription else { return }
            self.subscriptionLock.lock()
            self.subscribers.remove(subscription)
            self.subscriptionLock.unlock()
        } // Also mutation of `subscribers` need to be protected by lock
        
        return endObserving
    }
}
