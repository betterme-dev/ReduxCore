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
/// Store is a natural dispatcher
public final class Store<State>: Dispatcher {
    /// Store has its own queue, where all accesses and mutations are performed
    private let queue = DispatchQueue(label: "store private queue")
    private let subscriptionLock = UnfairLock()
    
    /// Current app state is stored here
    public private(set) var state: State
    
    private let reducer: Reducer<State>
    
    private var dispatch: Dispatch?
    
    /// Store should notify everyone about state changes
    private var subscribers: Set<CommandWith<State>> = []
    
    private let middlewares: [Middleware<State>]
    private let logger: ((_ action: Action) -> Void)?
    
    public init(
        state: State,
        reducer: @escaping Reducer<State>,
        middlewares: [Middleware<State>],
        logger: ((_ action: Action) -> Void)? = nil
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
        self.logger = logger
        
        self.dispatch = { action in
            let oldState = self.state
            let newState = self.reducer(self.state, action)
            self.state = newState
            self.middlewares.forEach { middleware in
                middleware(self.dispatch, action, oldState, newState)
            }
            self.subscriptionLock.lock()
            self.subscribers.forEach { $0.perform(with: newState) }
            self.subscriptionLock.unlock()
        }
    }
    
    /// Dispatch is async by nature.
    public func dispatch(action: Action) {
        logger?(action)
        queue.async {
            self.dispatch?(action)
        }
    }
    
    /// Observing a store will return a `Command` to stop observation
    @discardableResult
    public func observe(with command: CommandWith<State>) -> Command {
        subscriptionLock.lock()
        subscribers.insert(command)
        subscriptionLock.unlock()
        command.perform(with: state)
        /// Cancel observing should not keep link to command, so we need to use `weak` here
        let endObserving = Command(id: "Dispose observing for \(command)") { [weak command] in
            guard let command = command else { return }
            self.subscriptionLock.lock()
            self.subscribers.remove(command)
            self.subscriptionLock.unlock()
        } // Also mutation of `subscribers` need to be protected by lock
        
        return endObserving
    }
}
