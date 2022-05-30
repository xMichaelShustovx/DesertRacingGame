//
//  AppDelegate.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 20.01.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: MenuViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

