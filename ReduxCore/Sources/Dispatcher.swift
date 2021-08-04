//
//  Dispatcher.swift
//  ReduxCore
//
//  Copyright © 2021 Betterme. All rights reserved.
//

import Foundation

/// This protocol is the basic component of interactive action creators
public protocol Dispatcher {
    func dispatch(action: Action)
}

/// It is possible to add some extensions which will implement
/// compatibility with different parts of the system
public extension Dispatcher {
    func dispatch(command: CommandWith<Dispatcher>) {
        command.perform(with: self)
    }
}
