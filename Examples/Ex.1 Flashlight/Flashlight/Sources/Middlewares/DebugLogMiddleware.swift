//
//  DebugLogMiddleware.swift
//  Flashlight
//
//  Created by Maksym Husar  on 09.08.2021.
//

import Foundation
import ReduxCore
import os.log

struct DebugLogMiddleware {
    func middleware() -> Middleware<State> {
        { _, action, _, _ in
            switch action {
            case is Actions.UpdateDateMiddleware.UpdateCurrent:
                break
            default:
                os_log("%@",
                       log: OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: ""),
                       type: .debug,
                       "✳️ \(String(reflecting: action).prefix(500))")
            }
        }
    }
}
