//
//  Demo.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import Foundation

struct Demo {
    var title = "Demo"
    var subTitle: String?
    var className: String
    
    init(title: String, subTitle: String?, className: String) {
        self.title = title
        self.subTitle = subTitle
        self.className = className
    }
}
