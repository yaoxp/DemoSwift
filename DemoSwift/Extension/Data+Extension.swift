//
//  Data+Extension.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/15.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import Foundation

extension Data {
    /// 读取mainBundle中的文件
    /// - Parameter name: 文件名
    /// - Returns: Data
    static func dataNamed(_ name: String) -> Data? {
        let path = Bundle.main.path(forResource: name, ofType: nil)
        guard let path = path else { return nil }
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
    }
}
