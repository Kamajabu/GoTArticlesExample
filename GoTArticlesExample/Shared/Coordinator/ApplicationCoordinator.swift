//
//  ApplicationCoordinator.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    let mainStore: MainStore
    let window: UIWindow

    let rootViewController: UINavigationController
    let articlesListCoordinator: ArticlesListCoordinator

    init(window: UIWindow) {
        self.window = window

        mainStore = MainStore()
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true

        articlesListCoordinator = ArticlesListCoordinator(presenter: rootViewController, mainStore: mainStore)
        articlesListCoordinator.start()
    }

    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
