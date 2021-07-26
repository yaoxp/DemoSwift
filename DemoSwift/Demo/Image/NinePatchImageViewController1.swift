//
//  NinePatchImageViewController1.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/26.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class NinePatchImageViewController1: UIViewController {
    let imageView = UIImageView()
    /// .9图，size: 290 * 201  上: 136 - 152  左： 85 - 112. 不透明的黑线
    let imageName = "android.9.png"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let file = Bundle.main.path(forResource: imageName, ofType: nil),
           let image = UIImage(contentsOfFile: file) {
            imageView.image = NinePatchImageFactory.createStretchableImage(with: image)
        }
    }

}

// MARK: - UI
extension NinePatchImageViewController1 {
    private func setupUI() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
