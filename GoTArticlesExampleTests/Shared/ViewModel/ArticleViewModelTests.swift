//
//  ArticleViewModelTests.swift
//  GoTArticlesExampleTests
//
//  Created by Kamil Buczel on 19/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

@testable import GoTArticlesExample
import Nimble
import Quick
import RxSwift
import RxTest

class ArticleViewModelTests: QuickSpec {
    override func spec() {
        var viewModel: ArticleViewModel!
        var mockApiClient: ApiClientMock!
        var wikiaItemMock: WikiaItem!

        var disposeBag = DisposeBag()

        beforeEach {
            disposeBag = DisposeBag()
            mockApiClient = ApiClientMock()
            wikiaItemMock = WikiaItemMock.item(id: 12, title: "testTitle", url: "/testURL", abstract: "DetailsTest", thumbnail: nil)
            viewModel = ArticleViewModel(article: wikiaItemMock, apiClient: mockApiClient)
        }

        context("getter") {
            it("title should return valid value") {
                expect(viewModel.title) == wikiaItemMock.title
            }

            it("details should return valid value") {
                expect(viewModel.details) == wikiaItemMock.abstract
            }

            it("article addres should be create based on apiClient") {
                var urlComponents = URLComponents()
                urlComponents.host = "www.test.com"
                urlComponents.scheme = "https"
                mockApiClient.urlComponentsMock = urlComponents

                expect(viewModel.articleAddress?.absoluteString) == "https://www.test.com/testURL"
            }
        }

        context("details extended") {
            it("should change state of details extended to opposite") {
                expect(viewModel.detailsExtended) == false

                viewModel.updateDetailsVisibility()
                expect(viewModel.detailsExtended) == true

                viewModel.updateDetailsVisibility()
                expect(viewModel.detailsExtended) == false
            }

            it("should invoke event") {
                let testScheduler = TestScheduler(initialClock: 0)
                let observer = testScheduler.createObserver(Bool.self)

                viewModel.detailsExtendedDriver.asObservable().bind(to: observer).disposed(by: disposeBag)
                expect(observer.events) == [.next(0, false)]

                viewModel.updateDetailsVisibility()
                expect(observer.events) == [.next(0, false), .next(0, true)]

                viewModel.updateDetailsVisibility()
                expect(observer.events) == [.next(0, false), .next(0, true), .next(0, false)]
            }
        }

        context("is favourite") {
            it("should change state of favourite to opposite") {
                expect(viewModel.isFavourite) == false

                viewModel.updateFavourite()
                expect(viewModel.isFavourite) == true

                viewModel.updateFavourite()
                expect(viewModel.isFavourite) == false
            }

            it("should invoke event") {
                let testScheduler = TestScheduler(initialClock: 0)
                let observer = testScheduler.createObserver(Bool.self)

                viewModel.isFavouriteDriver.asObservable().bind(to: observer).disposed(by: disposeBag)
                expect(observer.events) == [.next(0, false)]

                viewModel.updateFavourite()
                expect(observer.events) == [.next(0, false), .next(0, true)]

                viewModel.updateFavourite()
                expect(observer.events) == [.next(0, false), .next(0, true), .next(0, false)]
            }
        }

        context("image fetch") {
            it("should return error on bad URL") {
                let testScheduler = TestScheduler(initialClock: 0)
                let thumbnailObserver = testScheduler.createObserver(Data.self)

                viewModel.articleThumbnailSingle.asObservable().bind(to: thumbnailObserver).disposed(by: disposeBag)

                expect(thumbnailObserver.events) == [.error(0, NetworkError.badURL)]
            }
        }
    }
}
