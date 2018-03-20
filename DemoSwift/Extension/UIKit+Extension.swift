//
//  UIKit+Extension.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/19.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

protocol NibLoadable {}

extension NibLoadable {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}
