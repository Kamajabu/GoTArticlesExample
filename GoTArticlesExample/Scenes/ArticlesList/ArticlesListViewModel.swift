//
//  ArticlesListViewModel.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ArticlesListViewModel {
    let isFiltrationOn = BehaviorRelay<Bool>.init(value: false)

    var articlesListSingle: Single<[WikiaItem]> {
        return apiClient
            .getWikiaArticles(withLimit: 75)
            .map { $0.items }
            .do(onSuccess: { [weak self] items in
                guard let self = self else {
                    return
                }

                self.articlesList = items.map {
                    ArticleViewModel(article: $0, apiClient: self.apiClient)
                }
            })
    }

    var articlesCount: Int {
        return isFiltrationOn.value ? favouriteArticlesList.count : articlesList.count
    }

    private let apiClient: NetworkClient
    private let disposeBag = DisposeBag()
    private var articlesList: [ArticleViewModel] = []

    private var favouriteArticlesList: [ArticleViewModel] {
        return articlesList.filter { $0.isFavourite }
    }

    init(apiClient: NetworkClient) {
        self.apiClient = apiClient
    }

    func articleViewModel(for index: Int) -> ArticleViewModel? {
        let articles = isFiltrationOn.value ? favouriteArticlesList : articlesList

        guard articles.indices.contains(index) else {
            return nil
        }

        return articles[index]
    }
}
