//
//  MainViewPresenter.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import Foundation
import ReduxCore

extension Actions {
    enum MainViewPresenter {
        struct Click: Action {}
    }
}

struct MainViewPresenter {
    private typealias Props = MainViewController.Props
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    let render: CommandWith<MainViewController.Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: State) {
        render.perform(
            with: Props(
                time: timeFormatter.string(from: state.date.current),
                isTorchEnabled: state.torchSettings.isEnabled,
                onClick: dispatch.bind(to: Actions.MainViewPresenter.Click(), id: "onClick"),
                onDestroy: endObserving
            )
        )
    }
}
