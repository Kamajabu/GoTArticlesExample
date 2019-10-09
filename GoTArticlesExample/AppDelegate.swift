//
//  AppDelegate.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let applicationCoordinator = ApplicationCoordinator(window: window)

        self.window = window
        self.applicationCoordinator = applicationCoordinator

        applicationCoordinator.start()
        return true
    }
}
