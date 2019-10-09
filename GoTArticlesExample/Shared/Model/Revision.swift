//
//  Revision.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import Foundation

struct Revision: Codable {
    let id: Int
    let user: String
    let userID: Int
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case id, user
        case userID = "user_id"
        case timestamp
    }
}
