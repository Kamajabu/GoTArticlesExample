//
//  ArticlesListCoordinator.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import UIKit

class ArticlesListCoordinator: Coordinator {
    private let presenter: UINavigationController

    private var articlesListViewController: ArticlesListViewController?
    private var articleDetailsCoordinator: ArticleDetailsCoordinator?

    private let mainStore: MainStore

    init(presenter: UINavigationController, mainStore: MainStore) {
        self.presenter = presenter
        self.mainStore = mainStore
    }

    func start() {
        let articlesViewModel = ArticlesListViewModel(apiClient: mainStore.apiClient)
        let articlesListViewController = ArticlesListViewController(viewModel: articlesViewModel, delegate: self)
        articlesListViewController.title = "Articles"

        presenter.pushViewController(articlesListViewController, animated: true)
        self.articlesListViewController = articlesListViewController
    }
}

extension ArticlesListCoordinator: ArticlesListViewControllerDelegate {
    func didSelectArticle(_ selectedArticle: ArticleViewModel) {
        let articleDetailsCoordinator = ArticleDetailsCoordinator(presenter: presenter,
                                                                  article: selectedArticle)
        articleDetailsCoordinator.start()

        self.articleDetailsCoordinator = articleDetailsCoordinator
    }
}
