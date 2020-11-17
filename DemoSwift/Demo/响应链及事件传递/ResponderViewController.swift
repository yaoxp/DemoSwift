//
//  ResponderViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/10/23.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit

class ResponderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.

        let button0 = UIButton(type: .system)
        button0.tag = 0
        if let cellType = ResponderDetailViewType(rawValue: 0) {
            button0.setTitle(cellType.description, for: .normal)
        }
        button0.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)

        let button1 = UIButton(type: .system)
        button1.tag = 1
        if let cellType = ResponderDetailViewType(rawValue: 1) {
            button1.setTitle(cellType.description, for: .normal)
        }
        button1.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)

        let button2 = UIButton(type: .system)
        button2.tag = 2
        if let cellType = ResponderDetailViewType(rawValue: 2) {
            button2.setTitle(cellType.description, for: .normal)
        }
        button2.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)

        let button3 = UIButton(type: .system)
        button3.setTitle("3. 学习事件传递和响应链", for: .normal)
        button3.addTarget(self, action: #selector(onButtonThreeAction(sender:)), for: .touchUpInside)

        view.addSubview(button0)
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)

        button0.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.centerY.equalToSuperview().offset(-89)
            $0.height.equalTo(22)
        }

        button1.snp.makeConstraints {
            $0.centerX.width.height.equalTo(button0)
            $0.top.equalTo(button0.snp.bottom).offset(30)
        }

        button2.snp.makeConstraints {
            $0.centerX.width.height.equalTo(button0)
            $0.top.equalTo(button1.snp.bottom).offset(30)
        }

        button3.snp.makeConstraints {
            $0.centerX.width.height.equalTo(button0)
            $0.top.equalTo(button2.snp.bottom).offset(30)
        }

        let textView = UITextView()
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(100)
        }

        textView.text = """
        0. label2正常响应点击事件
        1. label3忽略点击事件
        2. label4响应点击事件的范围大于label4的frame
        3. 学习事件传递和响应链
"""
    }

    @objc func onButtonAction(sender: UIButton) {
        let vc = ResponderDetailViewController()

        if let responseType = ResponderDetailViewType(rawValue: sender.tag) {
            vc.responseType = responseType
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func onButtonThreeAction(sender: UIButton) {
        let vc = ResponderDetailTwoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
