//
//  ReflectBaseModel.swift
//  DemoSwift
//
//  Created by yaoxp on 2020/11/18.
//  Copyright © 2020 yaoxp. All rights reserved.
//

import Foundation

class ReflectBaseModel {
    /// 返回类的信息，过滤掉值为nil的属性
    /// - Returns: 类的信息
    func modelInfo() -> String {
        var info = ""
        Mirror(reflecting: self).children.forEach { child in
            guard let label = child.label else { return }
            if let value = child.value as? Any? {
                switch value {
                case Optional.none:
                    return
                default:
                    info += "\(label): \(value!)\n"
                }
            }
        }
        return info
    }

    /// 返回类的信息，不做处理
    /// - Returns: 类的信息
    func originalModelInfo() -> String {
        var info = ""
        Mirror(reflecting: self).children.forEach { child in
            guard let label = child.label else { return }
            info += "\(label): \(child.value)\n"
        }
        return info
    }
}
