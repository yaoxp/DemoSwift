//
//  ResponderDetailViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/10/23.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

enum ResponderDetailViewType: Int {
    /// 正常处理点击事件
    case normal = 0
    /// 忽略点击事件
    case ignore = 1
    /// 点击的范围超过view也可以处理
    case big = 2

    var description: String {
        switch self {
        case .normal:
            return "普通"
        case .ignore:
            return "忽略点击事件"
        case .big:
            return "可点击范围大于view"
        }
    }
}

class ResponderDetailViewController: UIViewController {

    var responseType: ResponderDetailViewType = .normal
    let label1: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.backgroundColor = .red
        label.textColor = .black
        label.text = "label1"
        label.textAlignment = .center
        label.alpha = 0.5
        return label
    }()
    lazy var label2: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.backgroundColor = .blue
        label.textColor = .black
        label.text = "label2"
        label.textAlignment = .center
        label.alpha = 0.5
        return label
    }()
    lazy var label3: IgnoreTouchLabel = {
        let label = IgnoreTouchLabel()
        label.isUserInteractionEnabled = true
        label.backgroundColor = .blue
        label.textColor = .black
        label.text = "label3"
        label.textAlignment = .center
        label.alpha = 0.5
        return label
    }()
    lazy var label4: BigTouchLabel = {
        let label = BigTouchLabel()
        label.isUserInteractionEnabled = true
        label.backgroundColor = .blue
        label.textColor = .black
        label.text = "label4"
        label.textAlignment = .center
        label.alpha = 0.5
        return label
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.scrollsToTop = false
        textView.backgroundColor = UIColor.lightGray
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .green

        label1.backgroundColor = .red
        label1.text = "label1"
        label1.textAlignment = .center
        label1.alpha = 0.5
        label1.frame = CGRect(x: 50, y: 100, width: 150, height: 150)
        view.addSubview(label1)

        var firstResponseView: UIView

        switch responseType {
        case .normal:
            firstResponseView = label2
        case .ignore:
            firstResponseView = label3
        case .big:
            firstResponseView = label4
        }

        firstResponseView.backgroundColor = .blue
        firstResponseView.alpha = 0.5
        firstResponseView.frame = CGRect(x: 170, y: 220, width: 200, height: 200)
        view.addSubview(firstResponseView)

        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let hitView = view.hitTest(touch.location(in: view), with: event) {
                if hitView == label1 {
                    log("hit label1")
                } else if hitView == label2 {
                    log("hit label2")
                } else if hitView == label3 {
                    log("hit label3")
                } else if hitView == label4 {
                    log("hit label4")
                } else if hitView == view {
                    log("hit view")
                }
            }
        }
    }

}

extension ResponderDetailViewController {
    private func log(_ logInfo: String) {
        textView.text += (textView.text.lengthOfBytes(using: .utf8) == 0 ? "" : "\n") + logInfo

        let bottom = NSRange(location: textView.text.count - 1, length: 1)
        textView.scrollRangeToVisible(bottom)
    }
}
