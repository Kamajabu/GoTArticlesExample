//
//  WikiaItemMock.swift
//  GoTArticlesExampleTests
//
//  Created by Kamil Buczel on 19/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import Foundation
@testable import GoTArticlesExample

struct WikiaItemMock {
    static func item(id: Int, title: String, url: String, abstract: String, thumbnail: String?) -> WikiaItem {
        let revision = Revision(id: 123, user: "testUser", userID: 111, timestamp: "9999")
        let originalDiemensions = OriginalDimensions(width: 100, height: 100)
        return WikiaItem(id: id, title: title, ns: 0, url: url, revision: revision, abstract: abstract, thumbnail: thumbnail, originalDimensions: originalDiemensions)
    }
}
