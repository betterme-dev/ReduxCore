//
//  State.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import Foundation
import ReduxCore

struct State {
    let application: ApplicationState
    let date: DateState
    let torchSettings: TorchSettingsState
    
    static let initial = State(
        application: .initial,
        date: .initial,
        torchSettings: .initial
    )
}

func reduce(_ state: State, with action: Action) -> State {
    State(
        application: reduce(state.application, with: action),
        date: reduce(state.date, with: action),
        torchSettings: reduce(state.torchSettings, with: action)
    )
}
