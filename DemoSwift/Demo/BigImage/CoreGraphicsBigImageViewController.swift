//
//  CoreGraphicsBigImageViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/9/9.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class CoreGraphicsBigImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")

        let newImage = image!.resizeCG(imageView.bounds.size)

        imageView.image = newImage
        print("CoreGraphics: \(newImage!.size)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
