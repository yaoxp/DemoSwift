//
//  UIDevice+Extension.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

extension UIDevice {
    /// 是否是iPhone
    var isIPhone: Bool {
        return UIDevice.current.model == "iPhone"
    }

    /// 是否是iPad
    var isIPad: Bool {
        return UIDevice.current.model == "iPad"
    }

    /// 是否是iphone X
    /// - Returns: 是否是iphone X
    class func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }

        return false
    }
}
