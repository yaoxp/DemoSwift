//
//  DownsampleViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/26.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class DownsampleViewController: UIViewController {

    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        let imageName = "large_leaves_70mp.jpg"
        let path = Bundle.main.path(forResource: imageName, ofType: nil)
        assert(path != nil, "image path is nil: \(imageName)")
        let url = URL(fileURLWithPath: path!)
        let data = try? Data(contentsOf: url)
        assert(data != nil, "image is nil")
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data! as CFData, imageSourceOptions) else { return }
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                 kCGImageSourceShouldCacheImmediately: true,
                                 kCGImageSourceCreateThumbnailWithTransform: true,
                                 kCGImageSourceThumbnailMaxPixelSize:150 * UIScreen.main.scale] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return }
        let image = UIImage(cgImage: downsampledImage, scale: UIScreen.main.scale, orientation: .up)
//        let image = UIImage(named: imageName)
        print("image size: \(image.size)")
        imageView.image = image
    }

    deinit {
        print("DownsampleViewController")
    }
}

// MARK: - UI
extension DownsampleViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(150)
        }
    }
}
