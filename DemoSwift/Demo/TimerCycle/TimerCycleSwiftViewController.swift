//
//  TimerCycleSwiftViewController.swift
//  TimerTest
//
//  Created by YaoXinpan on 2021/6/3.
//  Copyright © 2021 YaoXinpan. All rights reserved.
//

import UIKit

@objc public class TimerCycleSwiftViewController: UIViewController {

    var timer: Timer!
    var counter = 0
    public override func viewDidLoad() {
        super.viewDidLoad()
//        func1()
//        func2()
        func3()
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
