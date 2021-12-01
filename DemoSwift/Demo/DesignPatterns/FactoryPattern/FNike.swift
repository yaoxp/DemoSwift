//
//  FOperationYouTiao.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/11/30.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit

class FNike: FShoesProtocol {
    var name: String {
        return "Nike"
    }

    func printInfo() {
        print("### \(name)")
    }
}
