//
//  ReflectViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2020/11/18.
//  Copyright © 2020 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class Student: ReflectBaseModel {
    var name: String? = "小明"
    var age = 18
    var address = "BeiJing"
    var code: Int?
    var money: Int? = 100
    var test: String?
    var test2: String? = "abc"
    var test3 = true
    var test4: Bool?
    var date = Date()
}

class ReflectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let textView = UITextView()
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let student = Student()
        textView.text = "\n类的原始信息：\n"
        textView.text += student.originalModelInfo()
        textView.text += "\n\n\n"
        textView.text += "过滤nil，并解开optional: \n"
        textView.text += student.modelInfo()
    }

}
