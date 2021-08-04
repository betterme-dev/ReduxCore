//
//  TorchSettingsState.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import Foundation
import ReduxCore

struct TorchSettingsState: Equatable {
    let isEnabled: Bool
    
    static let initial = TorchSettingsState(isEnabled: false)
}

func reduce(_ state: TorchSettingsState, with action: Action) -> TorchSettingsState {
    switch action {
    case let action as Actions.FlashlightMiddleware.Changed:
        return TorchSettingsState(isEnabled: action.isEnabled)
    default:
        return state
    }
}
