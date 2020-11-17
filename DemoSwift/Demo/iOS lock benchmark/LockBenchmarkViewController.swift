//
//  LockBenchmarkViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/12/14.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit

class LockBenchmarkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        for index in 0...4 {
            let button = UIButton(type: .custom)
            button.tag = Int(pow(10, Double(index + 3)))
            button.setTitleColor(.red, for: .normal)
            button.setTitle("run (\(button.tag))", for: .normal)
            button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
            view.addSubview(button)

            button.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(200)
                $0.height.equalTo(50)
                $0.top.equalToSuperview().offset(index * 60 + 160)
            }
        }
    }

    @objc func tap(sender: UIButton) {
        test(count: 1, log: false)
        test(count: sender.tag, log: true)
    }

    private func test(count: Int, log: Bool) {
        var begin: TimeInterval
        var end: TimeInterval

        do {
            var mutex = pthread_mutex_t()
            begin = CACurrentMediaTime()
            for _ in 0..<count {
                pthread_mutex_lock(&mutex)
                pthread_mutex_unlock(&mutex)
            }
            end = CACurrentMediaTime()
            pthread_mutex_destroy(&mutex)
            let time = (end - begin) * 1000
            if log {
                print(String(format: "Swift pthread_mutex_t:    %8.2f ms", time))
            }
        }

        do {
            // DispatchSemaphore
            let lock = DispatchSemaphore(value: 1)
            begin = CACurrentMediaTime()
            for _ in 0..<count {
                lock.wait()
                lock.signal()
            }
            end = CACurrentMediaTime()
            let time = (end - begin) * 1000 // 单位s
            if log {
                print(String(format: "Swift DispatchSemaphore:  %8.2f ms", time))
            }
        }

        do {
            let lock = NSCondition()
            begin = CACurrentMediaTime()
            for _ in 0..<count {
                lock.lock()
                lock.unlock()
            }
            end = CACurrentMediaTime()
            let time = (end - begin) * 1000
            if log {
                print(String(format: "Swift NSCondition:        %8.2f ms", time))
            }
        }

        do {
            let lock = NSLock()
            begin = CACurrentMediaTime()
            for _ in 0..<count {
                lock.lock()
                lock.unlock()
            }
            end = CACurrentMediaTime()
            let time = (end - begin) * 1000
            if log {
                print(String(format: "Swift NSLock:             %8.2f ms", time))
            }
        }

        do {
            let lock = NSRecursiveLock()
            begin = CACurrentMediaTime()
            for _ in 0..<count {
                lock.lock()
                lock.unlock()
            }
            end = CACurrentMediaTime()
            let time = (end - begin) * 1000
            if log {
                print(String(format: "Swift NSRecursiveLock:    %8.2f ms", time))
            }
        }

        do {
            let lock = NSConditionLock(condition: 1)
            begin = CACurrentMediaTime()
            for _ in 0..<count {
                lock.lock()
                lock.unlock()
            }
            end = CACurrentMediaTime()
            let time = (end - begin) * 1000
            if log {
                print(String(format: "Swift NSConditionLock:    %8.2f ms", time))
            }
        }

        do {
            let lock = NSObject()
            begin = CACurrentMediaTime()
            for _ in 0..<count {
                objc_sync_enter(lock)
                objc_sync_exit(lock)
            }
            end = CACurrentMediaTime()
            let time = (end - begin) * 1000
            if log {
                print(String(format: "Swift @synchronized:      %8.2f ms", time))
            }
        }

        OCLockBenchmark.shared().startTestLock(count, enableLog: log)

        if log {
            print("----- end \(count) -----\n\n")
        }
    }

}
