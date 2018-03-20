//
//  UIDevice+Extension.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

extension UIDevice {
    class func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
