//
//  IgnoreTouchLabel.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/10/23.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit

class IgnoreTouchLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        /// 忽略点击事件
        return nil
    }

}
