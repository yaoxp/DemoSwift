//
//  AppleDownsampleViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/13.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class AppleDownsampleViewController: UIViewController {

    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigTransparentImageName)")
        let url = URL(fileURLWithPath: path!)
        let data = try? Data(contentsOf: url)
        assert(data != nil, "image is nil")

        let downsampleSize = self.imageView.frame.size
        DispatchQueue.global().async {
            let downsampleImage = UIImage.downsample(data: data!, to: downsampleSize, scale: UIScreen.main.scale)
            DispatchQueue.main.async {
                self.imageView.image = downsampleImage
                print("image size: \(self.imageView.image?.size) scale: \(downsampleImage?.scale)")
                print("image view size: \(self.imageView.frame.size)")
            }
        }

    }

}

// MARK: - UI

extension AppleDownsampleViewController {
    func initUI() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.center.equalToSuperview()
        }
        view.backgroundColor = .white
    }
}


