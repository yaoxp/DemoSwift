//
//  UIApplication+Extension.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/7/29.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import Foundation

// MARK: - 性能
extension UIApplication {
    /// 应用占用内存量 MB
    /// http://www.samirchen.com/ios-app-memory-usage/
    static var memoryUsage: Double? {
        var info = task_vm_info_data_t()
        var size = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<natural_t>.size)
        let kern: kern_return_t = withUnsafeMutablePointer(to: &info) {
            task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0.withMemoryRebound(to: Int32.self, capacity: 1, {
                task_info_t($0)
            }), &size)
        }
        guard kern == KERN_SUCCESS else { return nil }
        return Double(info.phys_footprint) / 1024.0 / 1024.0
    }
}
