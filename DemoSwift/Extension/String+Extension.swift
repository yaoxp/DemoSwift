//
//  String+Extension.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/8/24.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// 获取字符串的宽度
    ///
    /// - Parameters:
    ///   - height: 字符串的高度
    ///   - font: 字体
    /// - Returns: 返回的宽度
    func width(height: CGFloat, font: UIFont) -> CGFloat {
        let textStr = self as NSString
        let rect = textStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return rect.width
    }
    
    /// 获取字符串的高度
    ///
    /// - Parameters:
    ///   - width: 字符串的宽度
    ///   - font: 字体
    /// - Returns: 返回的高度
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textStr = self as NSString
        let rect = textStr.boundingRect(with: CGSize(width:width , height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return rect.height
    }
}
