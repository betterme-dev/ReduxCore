//
//  UnfairLock.swift
//  ReduxCore
//
//  Copyright © 2021 Betterme. All rights reserved.
//

import Foundation

final class UnfairLock {
    private let _lock: os_unfair_lock_t

    init() {
        _lock = .allocate(capacity: 1)
        _lock.initialize(to: os_unfair_lock())
    }

    func lock() {
        os_unfair_lock_lock(_lock)
    }

    func unlock() {
        os_unfair_lock_unlock(_lock)
    }

    deinit {
        _lock.deinitialize(count: 1)
        _lock.deallocate()
    }
}
