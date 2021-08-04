//
//  AppDelegate.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import UIKit
import ReduxCore
import os.log

extension Actions {
    enum Application {
        struct DidFinishLaunch: Action {}
        struct DidEnterBackground: Action {}
        struct DidBecomeActive: Action {}
        struct WillResignActive: Action {}
        struct WillEnterForeground: Action {}
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private lazy var store = Store(
        state: State.initial,
        reducer: reduce,
        middlewares: [
            UpdateDateMiddleware().middleware(),
            FlashlightMiddleware().middleware(),
        ],
        logger: consoleLog
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        StoreLocator.populate(with: store)
        store.dispatch(action: Actions.Application.DidFinishLaunch())
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        store.dispatch(action: Actions.Application.DidEnterBackground())
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        store.dispatch(action: Actions.Application.DidBecomeActive())
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        store.dispatch(action: Actions.Application.WillResignActive())
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        store.dispatch(action: Actions.Application.WillEnterForeground())
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func consoleLog(_ action: Action) {
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
