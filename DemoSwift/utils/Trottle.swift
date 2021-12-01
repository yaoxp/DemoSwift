//
//  Trottle.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/12/1.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import Foundation

/// 节流阀
class Trottle {
    private var workItem = DispatchWorkItem(block: {})
    private var previousRun = Date.distantPast
    private let delay: TimeInterval
    private let queue: DispatchQueue

    /// initializer
    /// - Parameters:
    ///   - delay: 延迟时间，单位秒
    ///   - queue: 执行任务的对列
    init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }

    /// 使用节流阀执行的任务
    /// - Parameter block: 需要执行的任务
    func trottle(_ block: @escaping () -> Void) {
        workItem.cancel()

        workItem = DispatchWorkItem() { [weak self] in
            guard let self = self else { return }
            self.previousRun = Date()
            block()
        }
        let deltaDelay = previousRun.timeIntervalSinceNow > delay ? 0 : delay
        queue.asyncAfter(deadline: .now() + Double(deltaDelay), execute: workItem)
    }
}
