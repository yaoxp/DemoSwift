//
//  CountdownViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2020/11/17.
//  Copyright © 2020 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class CountdownViewController: UIViewController {
    let countdownButton = CountdownButton()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

}

// MARK: - user interaction
private extension CountdownViewController {
    @objc func onCountdownButtonAction(_ sender: CountdownButton) {
        countdownButton.start()
    }
}

// MARK: - setup UI
private extension CountdownViewController {
    func setupUI() {
        view.backgroundColor = .white
       setupCountdownButton()
    }
    
    func setupCountdownButton() {
        countdownButton.countdownTimeInterval = 50
        countdownButton.promptText = "再来一次呀"
        countdownButton.endHandler = { _ in
            print("######### countdown over")
        }
        countdownButton.setTitle("倒计时", for: .normal)
        countdownButton.setTitleColor(.black, for: .normal)
        countdownButton.backgroundColor = .gray
        countdownButton.sizeToFit()
        countdownButton.addTarget(self, action: #selector(onCountdownButtonAction(_:)), for: .touchUpInside)
        view.addSubview(countdownButton)
        countdownButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
