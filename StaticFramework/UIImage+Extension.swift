//
//  UIImage+Extension.swift
//  StaticFramework
//
//  Created by yaoxp on 2018/7/13.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import Foundation

extension UIImage {
    
     class func loadImageFromLocalBundle(name: String?) -> UIImage? {
        // 静态framework
        guard let bundlePath = Bundle.main.path(forResource: "Frameworks/StaticFramework.framework/StaticFramework", ofType: "bundle"), let imageBundle = Bundle(path: bundlePath) else { return nil }

        if let imagePath = imageBundle.path(forResource: name, ofType: "png") {
            
            return UIImage(contentsOfFile: imagePath)

        }
        
        return nil

    }
    
}
