//
//  ManualDecodeViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/27.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

/// 手动解码图片
class ManualDecodeViewController: UIViewController {
    let imageView = UIImageView()
    let imageName = "ant.png"

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

// MARK: - UI
extension ManualDecodeViewController {
    private func setupUI() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
