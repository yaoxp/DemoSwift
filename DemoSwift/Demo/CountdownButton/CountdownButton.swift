//
//  CountdownButton.swift
//  DemoSwift
//
//  Created by yaoxp on 2020/11/17.
//  Copyright © 2020 yaoxp. All rights reserved.
//

import UIKit

class CountdownButton: UIButton {
    // MARK: - public properties
    /// 倒计时时长，单位秒
    var countdownTimeInterval = 60
    /// 倒计时结束时，button显示的信息
    var promptText = "再次获取"
    /// 倒计时结束时的回调
    var endHandler: ((Int) -> Void)?
    private var timer: CountDownTimer?
    
    // MARK: - life cycle
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CountdownButton {
    // MARK: - begin countdown
    func start() {
        if timer == nil {
            timer = CountDownTimer.scheduledTimer(totalTime: countdownTimeInterval) { [weak self] _, timeInterval in
                guard let self = self else { return }
                if timeInterval <= 0 {
                    // 倒计时结束
                    self.isEnabled = true
                    self.setTitle(self.promptText, for: .normal)
                    self.endHandler?(timeInterval)
                } else {
                    self.setTitle("\(timeInterval)S", for: .normal)
                }
            }
        }
        timer?.resume()
        isEnabled = false
    }
}
