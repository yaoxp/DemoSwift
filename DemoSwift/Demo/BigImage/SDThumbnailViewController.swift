//
//  SDThumbnailViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/13.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit

class SDThumbnailViewController: UIViewController {
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")
        let resizedImage = image?.sd_resizedImage(with: imageView.frame.size, scaleMode: .aspectFill)
        imageView.image = resizedImage
        print("image size: \(imageView.image?.size) scale: \(resizedImage?.scale)")
        print("image view size: \(imageView.frame.size)")
    }

}

// MARK: - UI

extension SDThumbnailViewController {
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
