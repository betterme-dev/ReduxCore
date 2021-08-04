//
//  ApplicationState.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import Foundation
import ReduxCore

enum ApplicationState: Equatable {
    case active
    case inactive
    case background
    
    static let initial = ApplicationState.active
}

func reduce(_ state: ApplicationState, with action: Action) -> ApplicationState {
    switch action {
    case is Actions.Application.DidEnterBackground:
        return .background
    case is Actions.Application.DidBecomeActive:
        return .active
    case is Actions.Application.WillResignActive:
        return .inactive
    default:
        return state
    }
}
