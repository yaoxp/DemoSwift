//
//  SDOriginalViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/13.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class SDOriginalViewController: UIViewController {

    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

        view.backgroundColor = .white

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")

        let decodedImage = UIImage.sd_decodedImage(with: image)
        imageView.image = decodedImage

        print("image size: \(imageView.image?.size) scale: \(decodedImage?.scale)")
        print("image view size: \(imageView.frame.size)")
    }

    deinit {
        imageView.image = nil
        print("\(#file) deinit")
    }

}

// MARK: - UI

extension SDOriginalViewController {
    func initUI() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.center.equalToSuperview()
        }
    }
}
