//
//  PayTheBillHeaderView.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/19.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class PayTheBillHeaderView: UIView, NibLoadable {

    @IBOutlet weak var iconImgView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var imgViewHeightAndWidth: NSLayoutConstraint!

    @IBOutlet weak var imgViewLeading: NSLayoutConstraint!
}
