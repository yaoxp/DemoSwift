//
//  DynamicAndStaticViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/7/13.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit
import DynamicFramework
import StaticFramework

class DynamicAndStaticViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white

        // 动态framework
        let dynamicFrameworkView = DynamicFrameworkView(frame: CGRect(x: 15, y: 100, width: 160, height: 100))
        view.addSubview(dynamicFrameworkView)

        // 静态framework
        let staticFrameworkView = StaticFrameworkView(frame: CGRect(x: 15, y: 250, width: 160, height: 100))
        view.addSubview(staticFrameworkView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
