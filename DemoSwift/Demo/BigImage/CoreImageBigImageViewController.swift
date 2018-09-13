//
//  CoreImageBigImageViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/9/10.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class CoreImageBigImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let path = Bundle.main.bundlePath + "/IMG_001.png"
        let image = UIImage(contentsOfFile: path)
        
        let newImage = image!.resizeCI(imageView.bounds.size)
        imageView.image = newImage
        print("CoreImage: \(newImage!.size)")
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
