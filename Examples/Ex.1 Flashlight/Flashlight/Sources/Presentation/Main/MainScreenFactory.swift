//
//  MainScreenFactory.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import UIKit
import ReduxCore

struct MainScreenFactory {
    private let store: Store<State>
    
    init(store: Store<State> = StoreLocator.shared) {
        self.store = store
    }
    
    func `default`() -> MainViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        var endObserving: Cancellation?
        let presenter = MainViewPresenter(
            render: CommandWith { [weak controller] props in
                controller?.render(props: props)
            }.dispatchedOnMain(),
            dispatch: CommandWith { [weak store] action in
                store?.dispatch(action: action)
            },
            endObserving: Command { endObserving?.cancel() }
        )
        endObserving = store.observe(with: presenter.present)
        return controller
    }
}
