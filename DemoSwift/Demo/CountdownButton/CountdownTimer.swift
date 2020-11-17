//
//  CountdownTimer.swift
//  DemoSwift
//
//  Created by yaoxp on 2020/11/17.
//  Copyright © 2020 yaoxp. All rights reserved.
//

import Foundation
import UIKit

/// 倒计时计时器必须实现的方法
protocol CountDownTimerProtocol {
    /// 开始计时
    func resume()
    /// 停止计时
    func suspend()
    /// 销毁计时器
    func cancel()
}

/// 倒计时计时器
final class CountDownTimer {

    /// 倒计时时长，单位秒
    private var countDownTime = 60
    /// 倒计时结束时间
    private var endTime = CFTimeInterval(0)
    /// 倒计时剩余时间
    private var remainingTime = 0
    /// 倒计时单位长度 S
    private var timeInterval: Int = 1

    private var timer: DispatchSourceTimer!

    static func scheduledTimer(withTimeInterval interval: Int = 1, totalTime: Int, block: @escaping (CountDownTimer, Int) -> Void) -> CountDownTimer {
        let countDownTimer = CountDownTimer(withTimeInterval: interval, totalTime: totalTime, block: block)
        return countDownTimer
    }

    private init(withTimeInterval interval: Int = 1, totalTime: Int, block: @escaping (CountDownTimer, Int) -> Void) {
        countDownTime = totalTime
        remainingTime = totalTime
        timeInterval = interval
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.global())
        timer.schedule(deadline: .now() + .seconds(0), repeating: Double(timeInterval))
        timer.setEventHandler {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.remainingTime = lround(self.endTime - CACurrentMediaTime())
                if self.remainingTime <= 0 {
                    self.suspend()
                }
                block(self, self.remainingTime)
            }
        }
    }
}

extension CountDownTimer: CountDownTimerProtocol {
    func resume() {
        endTime = CACurrentMediaTime() + CFTimeInterval(countDownTime)
        timer.resume()
    }

    func suspend() {
        timer.suspend()
    }

    func cancel() {
        timer.cancel()
    }
}
