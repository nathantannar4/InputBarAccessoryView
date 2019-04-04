//
//  AppDelegate.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2019 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: InputBarStyleSelectionController())
        window?.makeKeyAndVisible()
                
        return true
    }
}
