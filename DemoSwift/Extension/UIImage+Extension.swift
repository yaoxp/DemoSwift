//
//  UIImage+Extension.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/19.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

extension UIImage {
    class func createImage(color: UIColor, frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)

        if let context = UIGraphicsGetCurrentContext() {
            
            context.setFillColor(color.cgColor)
            
            context.fill(frame)
            
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return theImage
        }
        
        return nil
        
    }
    
    class func createImage(color: UIColor) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        UIGraphicsBeginImageContext(frame.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setFillColor(color.cgColor)
            
            context.fill(frame)
            
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return theImage
        }
        
        return nil
        
    }
}
