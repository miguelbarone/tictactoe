//
//  AppDelegate.swift
//  TicTacToe
//
//  Created by Miguel Barone on 31/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = UINavigationController(rootViewController: MainViewController())
        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}

