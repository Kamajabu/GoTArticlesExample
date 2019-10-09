//
//  WikiaItem.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import Foundation

struct WikiaItem: Codable {
    let id: Int
    let title: String
    let ns: Int
    let url: String
    let revision: Revision
    let abstract: String
    let thumbnail: String?
    let originalDimensions: OriginalDimensions?

    enum CodingKeys: String, CodingKey {
        case id, title, ns, url, revision, abstract, thumbnail
        case originalDimensions = "original_dimensions"
    }
}
