//
//  TimerCycleViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/6/2.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class TimerCycleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        // Do any additional setup after loading the view.
        setupUI()
    }

    @objc func openOCTimerLeakVC() {
        let vc = OCTimerLeakViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func openSwiftTimerLeakVC() {
        let vc = TimerCycleSwiftViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension TimerCycleViewController {
    func setupUI() {
        setupOCTimerLeak()
        setupSwiftTimerLeak()
    }

    func setupOCTimerLeak() {
        let button = UIButton()
        button.setTitle("OC 循环引用", for: .normal)
        button.addTarget(self, action: #selector(openOCTimerLeakVC), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
    }

    func setupSwiftTimerLeak() {
        let button = UIButton()
        button.setTitle("Swift 循环引用", for: .normal)
        button.addTarget(self, action: #selector(openSwiftTimerLeakVC), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(200)
        }
    }
}
