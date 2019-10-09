//
//  UITableViewCell+extensions.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
