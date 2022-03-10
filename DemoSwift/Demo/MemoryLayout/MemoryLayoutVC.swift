//
//  MemoryLayoutVC.swift
//  DemoSwift
//
//  Created by yaoxp on 2022/1/11.
//  Copyright © 2022 yaoxp. All rights reserved.
//

import UIKit


class MemoryLayoutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        intMemoryLayout()
        stringMemoryLayout()
    }

    func getPointer<T>(of value: inout T) -> UnsafeRawPointer {
        return withUnsafePointer(to: &value, { UnsafeRawPointer($0) })
    }


    /// 整数内存布局
    func intMemoryLayout() {
        printBegin("int")
        var num = 100
        print("int address: \(getPointer(of: &num)) 栈上")
        print("int size: \(MemoryLayout.size(ofValue: num))")
        print("int stride: \(MemoryLayout.stride(ofValue: num))")
        print("int alignment: \(MemoryLayout.alignment(ofValue: num))")
        printEnd("int")
    }

    func stringMemoryLayout() {
        printBegin("String")
        printMark("长度小于15 分配在栈上")
        var str1 = "0123abc"
        print("int address: \(getPointer(of: &str1))")
        print("int size: \(MemoryLayout.size(ofValue: str1))")
        print("int stride: \(MemoryLayout.stride(ofValue: str1))")
        print("int alignment: \(MemoryLayout.alignment(ofValue: str1))")
        printMark("常量 长度大于15 分配在__text")
        var str2 = "0123456789abcdefghijklmn"
        print("int address: \(getPointer(of: &str2))")
        print("int size: \(MemoryLayout.size(ofValue: str2))")
        print("int stride: \(MemoryLayout.stride(ofValue: str2))")
        print("int alignment: \(MemoryLayout.alignment(ofValue: str2))")
        printMark("非常量 长度大于15 分配在堆上")
        str1.append("01234567890asdfg")
        print("int address: \(getPointer(of: &str1))")
        print("int size: \(MemoryLayout.size(ofValue: str1))")
        print("int stride: \(MemoryLayout.stride(ofValue: str1))")
        print("int alignment: \(MemoryLayout.alignment(ofValue: str1))")
        printEnd("String")
    }
}

// MARK: - print
extension MemoryLayoutVC {
    func printBegin(_ mark: String) {
        print("\n########## \(mark) begin ##########")
    }

    func printEnd(_ mark: String) {
        print("########## \(mark) end ##########")
    }

    func printMark(_ mark: String) {
        print("######## \(mark) ########")
    }
}
