//
//  UIKitBigImageViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/9/9.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

/*
    用于图像大小调整的最高级API可以在UIKit框架中找到。给定一个UIImage，可以使用临时图形上下文来渲染缩放版本。
 这种方式最简单，效果也不错，但不太建议使用这种方式。
 UIKit处理大分辨率图片时，往往容易出现OOM，原因是-[UIImage drawInRect:]在绘制时，先解码图片，再生成原始分辨率大小的bitmap，
 这是很耗内存的。解决方法是使用更低层的ImageIO接口，避免中间bitmap产生。
 */

import UIKit

class UIKitBigImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.bundlePath + "/IMG_001.png"
        let image = UIImage(contentsOfFile: path)

        let newImage = image?.resizeUI(imageView.frame.size)

        imageView.image = newImage
        print("UIKit: \(newImage!.size)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
