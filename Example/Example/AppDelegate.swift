//
//  AppDelegate.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2018 Nathan Tannar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UIApplication.shared.statusBarStyle = .lightContent
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: InputBarStyleSelectionController())
        window?.makeKeyAndVisible()
                
        return true
    }
    
}

