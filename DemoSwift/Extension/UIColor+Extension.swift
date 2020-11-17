//
//  UIColor+Extension.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) -> UIColor {
        return UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha / 1.0)
    }

    class func hexRGB(_ rgbValue: Int, _ alpha: CGFloat) -> UIColor {
        return UIColor.init(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: alpha / 1.0)
    }
}
