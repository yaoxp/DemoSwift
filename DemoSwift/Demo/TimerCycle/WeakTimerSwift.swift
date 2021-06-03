//
//  WeakTimerSwift.swift
//  TimerTest
//
//  Created by YaoXinpan on 2021/6/3.
//  Copyright © 2021 YaoXinpan. All rights reserved.
//

import UIKit

class WeakTimerSwift: NSObject {
    weak var target: NSObjectProtocol?
    var sel: Selector?
    weak var timer: Timer?

    open class func scheduledTimer(timeInterval time: TimeInterval, target aTarget: NSObjectProtocol, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> Timer {
        let weakTimer = WeakTimerSwift()
        weakTimer.target = aTarget
        weakTimer.sel = aSelector
        weakTimer.timer = Timer.scheduledTimer(timeInterval: time, target: weakTimer, selector: #selector(fire(_:)), userInfo: userInfo, repeats: yesOrNo)
        return weakTimer.timer!
    }

    deinit {
        print("### WeakTimerSwift deinit")
        timer?.invalidate()
        timer = nil
    }

    @objc func fire(_ timer: Timer) {
        guard let target = target,
            let sel = sel,
            target.responds(to: sel) else {
                self.timer?.invalidate()
                self.timer = nil
                return
        }
        target.perform(sel, with: timer.userInfo)
    }
}
