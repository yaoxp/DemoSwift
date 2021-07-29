//
//  ManualDecodeViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/29.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit

class ManualDecodeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageSize: UILabel!
    @IBOutlet weak var beforeDecodeMemoryUsage: UILabel!
    @IBOutlet weak var afterDecodeMemoryUsage: UILabel!
    let imageNameText = "ant@3x.png"

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = UIImage(named: imageNameText, in: Bundle.main, compatibleWith: nil) else { return }
        self.imageName.text = (self.imageSize.text ?? "") + imageNameText
        imageSize.text = (imageSize.text ?? "") + "\(image.size.width.string(accurate: 2)) * \(image.size.height.string(accurate: 2))"
    }

    @IBAction func onDecodeButtonAction(_ sender: Any) {
        if let memoryUsage = UIApplication.memoryUsage {
            beforeDecodeMemoryUsage.text = (beforeDecodeMemoryUsage.text ?? "") + memoryUsage.string(accurate: 2)
        }
        guard let image = UIImage(named: imageNameText, in: Bundle.main, compatibleWith: nil) else { return }
        UIImage.decodeImage2(image, completion: { newImage in
            if newImage != nil {
                if let memoryUsage = UIApplication.memoryUsage {
                    self.afterDecodeMemoryUsage.text = (self.afterDecodeMemoryUsage.text ?? "") + memoryUsage.string(accurate: 2)
                    print("newImage size: \(newImage?.size)")
                }
            } else {
                self.afterDecodeMemoryUsage.text = (self.afterDecodeMemoryUsage.text ?? "") + "decode error"
            }
        })
    }
    

}
