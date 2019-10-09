//
//  ArticlesViewModel.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 18/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ArticleViewModel {
    var isFavourite: Bool {
        return isFavouriteRelay.value
    }

    var detailsExtended: Bool {
        return detailsExtendedRelay.value
    }

    var articleThumbnailSingle: Single<Data> {
        guard let thumbnailAddress = article.thumbnail else {
            return .error(NetworkError.badURL)
        }

        return apiClient
            .getImageData(from: thumbnailAddress)
    }

    var detailsExtendedDriver: Driver<Bool> {
        return detailsExtendedRelay
            .asDriver()
    }

    var isFavouriteDriver: Driver<Bool> {
        return isFavouriteRelay
            .asDriver()
    }

    var title: String {
        return article.title
    }

    var details: String {
        return article.abstract
    }

    var articleAddress: URL? {
        var urlComponents = apiClient.urlComponents
        urlComponents.path = article.url
        return urlComponents.url
    }

    private let article: WikiaItem
    private unowned let apiClient: NetworkClient

    private var detailsExtendedRelay = BehaviorRelay<Bool>.init(value: false)
    private var isFavouriteRelay = BehaviorRelay<Bool>.init(value: false)

    init(article: WikiaItem, apiClient: NetworkClient) {
        self.article = article
        self.apiClient = apiClient
    }

    // Instead of relays we could propagate event through subject and .toggle() states in do, but
    // current approach is good enough I think.
    func updateDetailsVisibility() {
        let currentValue = detailsExtendedRelay.value
        detailsExtendedRelay.accept(!currentValue)
    }

    func updateFavourite() {
        let currentValue = isFavouriteRelay.value
        isFavouriteRelay.accept(!currentValue)
    }
}
