//
//  ArticlesListViewModelTests.swift
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

class ArticlesListViewModelTests: QuickSpec {
    override func spec() {
        var viewModel: ArticlesListViewModel!
        var mockApiClient: ApiClientMock!

        var disposeBag = DisposeBag()

        beforeEach {
            disposeBag = DisposeBag()
            mockApiClient = ApiClientMock()

            mockApiClient.wikiaArticlesToReturn = .just(WikiaArticlesMock.item())
            viewModel = ArticlesListViewModel(apiClient: mockApiClient)
        }

        describe("getter") {
            beforeEach {
                viewModel.articlesListSingle.subscribe().disposed(by: disposeBag)
            }

            context("is not filtered") {
                it("articlesCount should return valid value") {
                    expect(viewModel.articlesCount) == 10
                }

                it("articleViewModel will return nil for non existing item") {
                    expect(viewModel.articleViewModel(for: 99)).to(beNil())
                }
            }

            context("is filtered") {
                it("articlesCount should return valid value") {
                    expect(viewModel.articlesCount) == 10

                    viewModel.articleViewModel(for: 2)?.updateFavourite()
                    viewModel.articleViewModel(for: 4)?.updateFavourite()
                    viewModel.isFiltrationOn.accept(true)

                    expect(viewModel.articlesCount) == 2

                    viewModel.isFiltrationOn.accept(false)
                    expect(viewModel.articlesCount) == 10
                }

                it("articleViewModel should return valid index based on filtration state") {
                    let element = viewModel.articleViewModel(for: 8)
                    expect(element?.title) == "title8"

                    expect(viewModel.articleViewModel(for: 0)?.title) == "title0"

                    element?.updateFavourite()
                    viewModel.isFiltrationOn.accept(true)

                    expect(viewModel.articleViewModel(for: 0)?.title) == element?.title
                }
            }
        }
    }
}
