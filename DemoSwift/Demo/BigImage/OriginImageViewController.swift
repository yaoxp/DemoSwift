//
//  OriginImageViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/9/12.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class OriginImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")

        imageView.image = image

        print("origin size: \(image!.size)")
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
