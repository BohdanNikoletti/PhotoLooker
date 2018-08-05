//
//  AppDelegate.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 29.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import UIKit
import FTLinearActivityIndicator

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
    prepareWindowAndAppearanceOf(application: application)
    instantiateInitialViewController()
    return true
  }
}
private extension AppDelegate {
  func instantiateInitialViewController() {
    
    let historyController = HistoryController()
    let navigationController = UINavigationController(rootViewController: historyController)
    navigationController.navigationBar.barTintColor = AppColors.primaryDark
    navigationController.navigationBar.tintColor = AppColors.primary
    navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    
    window?.rootViewController = navigationController
  }
  func prepareWindowAndAppearanceOf(application: UIApplication) {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    application.statusBarStyle = .lightContent
  }
}
