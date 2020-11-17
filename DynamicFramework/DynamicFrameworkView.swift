//
//  DynamicFrameworkView.swift
//  DynamicFramework
//
//  Created by yaoxp on 2018/7/13.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

public class DynamicFrameworkView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        // 动态库
        let image = UIImage.loadImageFromLocalBundle(name: "alert")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(imageView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
