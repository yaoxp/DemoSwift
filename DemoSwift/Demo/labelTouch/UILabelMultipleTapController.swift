//
//  UILabelMultipleTapController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/3/22.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class UILabelMultipleTapController: UIViewController {

    lazy var label = UILabel()
    let text = "已阅读并接受《公司协议》和《隐私协议》和《未成年人保护协议》"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupUI()
    }

    func setupUI() {
        view.addSubview(label)
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.snp.makeConstraints {
            $0.center.width.equalToSuperview()
        }
    }

}
