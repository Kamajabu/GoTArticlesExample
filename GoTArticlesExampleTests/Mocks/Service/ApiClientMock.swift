//
//  ApiClientMock.swift
//  GoTArticlesExampleTests
//
//  Created by Kamil Buczel on 19/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

@testable import GoTArticlesExample
import RxCocoa
import RxSwift

enum ApiMockError: Error {
    case mockMissing
}

class ApiClientMock: NetworkClient {
    var wikiaArticlesToReturn: Single<WikiaArticles>?
    var imageDataResponse: Single<Data>?
    var urlComponentsMock: URLComponents?

    func getWikiaArticles(withLimit _: Int) -> Single<WikiaArticles> {
        guard let response = wikiaArticlesToReturn else {
            return .error(ApiMockError.mockMissing)
        }

        return response
    }

    func getImageData(from _: String) -> Single<Data> {
        guard let response = imageDataResponse else {
            return .error(ApiMockError.mockMissing)
        }

        return response
    }

    var urlComponents: URLComponents {
        return urlComponentsMock ?? URLComponents()
    }
}
