//
//  AppDelegate.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let historyController = HistoryController()
        let navigationController = UINavigationController(rootViewController: historyController)
        navigationController.navigationBar.barTintColor = AppColors.primaryDark
        navigationController.navigationBar.tintColor = AppColors.primary

        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        window?.rootViewController = navigationController
                
        application.statusBarStyle = .lightContent
        
        return true
    }
}

