//
//  TimerCycleSwiftViewController.swift
//  TimerTest
//
//  Created by YaoXinpan on 2021/6/3.
//  Copyright © 2021 YaoXinpan. All rights reserved.
//

import UIKit

class TimerBlock<T> {
    let f: T
    init(_ f: T) {
        self.f = f
    }
}

extension Timer {
    static func appScheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
        }
        return Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(weakTimerAction(_:)), userInfo: TimerBlock(block), repeats: repeats)
    }

    @objc static func weakTimerAction(_ sender: Timer) {
        if let block = sender.userInfo as? TimerBlock<(Timer) -> Void> {
            block.f(sender)
        }
    }
}

@objc public class TimerCycleSwiftViewController: UIViewController {

    var timer: Timer!
    var counter = 0
    public override func viewDidLoad() {
        super.viewDidLoad()
//        func1()
//        func2()
//        func3()
        func4()
    }

    /// 泄露
    func func1() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    /// 不泄露
    func func2() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.timerAciont2()
        })
    }

    /// 不泄露
    func func3() {
        timer = WeakTimerSwift.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    func func4() {
        timer = Timer.appScheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            print("### ###")
            self?.timerAciont2()
        })
    }

    deinit {
        print("### TimerCycleViewController deinit")
        timer.invalidate()
        timer = nil
    }
    
    @objc func timerAction() {
        counter += 1
        print("### \(counter)")
    }
    
    func timerAciont2() {
        counter += 1
        print("### \(counter)")
    }

}
