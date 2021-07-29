//
//  Number+Extension.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/29.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import Foundation

import UIKit

extension CGFloat {
    /// 返回字符串
    /// - Parameter accurate: 小数点后几位
    /// - Returns: 转化后的字符串
    func string(accurate: Int) -> String {
        return String(format: "%0.\(accurate)f", self)
    }

    /// 适配不同屏幕后的尺寸
    var universalValue: CGFloat {
        let multiplied: CGFloat = UIDevice.current.isIPad ? 1.6 : 1
        return self * multiplied
    }
}

extension Int {
    /// 转化成的字符串
    var string: String {
        return "\(self)"
    }
    /// 适配不同屏幕后的尺寸
    var universalValue: CGFloat {
        let multiplied: CGFloat = UIDevice.current.isIPad ? 1.6 : 1
        return CGFloat(self) * multiplied
    }
}

extension Double {
    /// 返回字符串
    /// - Parameter accurate: 小数点后几位
    /// - Returns: 转化后的字符串
    func string(accurate: Int) -> String {
        return String(format: "%0.\(accurate)f", self)
    }

    /// 适配不同屏幕后的尺寸
    var universalValue: CGFloat {
        let multiplied: CGFloat = UIDevice.current.isIPad ? 1.6 : 1
        return CGFloat(self) * multiplied
    }
}
