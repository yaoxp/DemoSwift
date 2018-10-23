//
//  BigTouchLabel.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/10/23.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit

class BigTouchLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newBounds = bounds.insetBy(dx: -20, dy: -20)
        return newBounds.contains(point)
    }

}
