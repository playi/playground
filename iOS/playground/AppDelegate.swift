//
//  AppDelegate.swift
//  something
//
//  Created by Jelle Alten on 11-11-16.
//  Copyright © 2016 Alt-N. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.delegate = self;
        }

        return true
    }


}

