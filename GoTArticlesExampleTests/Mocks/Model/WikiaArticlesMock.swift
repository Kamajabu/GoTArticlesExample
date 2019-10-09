//
//  WikiaArticlesMock.swift
//  GoTArticlesExampleTests
//
//  Created by Kamil Buczel on 19/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import Foundation
@testable import GoTArticlesExample

struct WikiaArticlesMock {
    static func item() -> WikiaArticles {
        let items = (0 ..< 10)
            .map { WikiaItemMock.item(id: $0, title: "title\($0)", url: "/ur/\($0)",
                                      abstract: "abstract\($0)", thumbnail: "thumbnail\($0)")
            }

        return WikiaArticles(basepath: "basePathTest", items: items)
    }
}
