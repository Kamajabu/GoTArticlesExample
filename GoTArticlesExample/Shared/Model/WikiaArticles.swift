//
//  WikiaArticles.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import Foundation

struct WikiaArticles: Codable {
    let basepath: String
    let items: [WikiaItem]
}
