//
//  UpdateDateMiddleware.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import Foundation
import ReduxCore

extension Actions {
    enum UpdateDateMiddleware {
        struct UpdateCurrent: Action {
            let date: Date
        }
    }
}

struct UpdateDateMiddleware {
    func middleware(getDate: @escaping () -> Date = Date.init) -> Middleware<State> {
        var timer: Timer?
        // capture a reference to the outer variables that you happen to use inside the closure
        return { dispatch, action, _, _ in
            if timer == nil {
                let newTimer = Timer(timeInterval: 0.5, repeats: true) { _ in
                    dispatch(Actions.UpdateDateMiddleware.UpdateCurrent(date: getDate()))
                }
                RunLoop.main.add(newTimer, forMode: .common)
                timer = newTimer
            }
            
            switch action {
            case is Actions.Application.DidBecomeActive,
                 is Actions.Application.DidFinishLaunch,
                 is Actions.Application.WillEnterForeground:
                dispatch(Actions.UpdateDateMiddleware.UpdateCurrent(date: getDate()))
            default:
                break
            }
        }
    }
}
