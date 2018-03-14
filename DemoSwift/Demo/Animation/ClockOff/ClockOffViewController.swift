//
//  ClockOffViewController.swift
//  Animation
//
//  Created by yaoxinpan on 2018/3/9.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class ClockOffViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        title = "打卡下班"
        let clockOffButton = ClockOffButton()

        clockOffButton.setTitle("打卡 ", for: .normal)
        clockOffButton.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(clockOffButton)
        clockOffButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(150)
            make.center.equalTo(view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
