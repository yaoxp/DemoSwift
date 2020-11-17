//
//  UIImage+Extension.swift
//  DynamicFramework
//
//  Created by yaoxp on 2018/7/13.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import Foundation

extension UIImage {

    class func loadImageFromLocalBundle(name: String?) -> UIImage? {
        // 动态framework
        let bundle = Bundle(for: DynamicFrameworkView.self)

        guard let url = bundle.url(forResource: "DynamicFramework", withExtension: "bundle"), let imageBundle = Bundle(url: url) else { return nil }

        if let imagePath = imageBundle.path(forResource: name, ofType: "png") {

            return UIImage(contentsOfFile: imagePath)

        }

        return nil

        /*
        // 和静态framework一致也可以
        guard let bundlePath = Bundle.main.path(forResource: "Frameworks/DynamicFramework.framework/DynamicFramework", ofType: "bundle"), let imageBundle = Bundle(path: bundlePath) else { return nil }
        
        if let imagePath = imageBundle.path(forResource: name, ofType: "png") {
            
            return UIImage(contentsOfFile: imagePath)
            
        }
        
        return nil
 */

    }

}
