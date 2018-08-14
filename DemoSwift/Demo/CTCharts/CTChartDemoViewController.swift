//
//  CTChartDemoViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/8/13.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class CTChartDemoViewController: UIViewController {

    let color1 = UIColor.hexRGB(0xFF5E00, 1.0)
    let color2 = UIColor.hexRGB(0x00D09D, 1.0)
    let color3 = UIColor.hexRGB(0x00BBDD, 1.0)
    
    @IBOutlet weak var cellView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let chartView = CTChartView.loadViewFromNib()
        cellView.addSubview(chartView)
//        cellView.backgroundColor = UIColor.lightGray
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        var data1 = CTChartViewData()
        data1.name = "影响用户数"
        data1.yAxis = .left
        data1.yAxisData = [723, 321, 19, 456, 765, 423, 666]
        data1.xAxisData = ["8:00", "9:00", "10.00", "11:00", "12:00", "13:00", "14:00"]
        data1.lineColor = color1
        
        var data2 = CTChartViewData()
        data2.name = "用户数"
        data2.yAxis = .right
        data2.yAxisData = [234, 421, 159, 756, 1000, 523, 266]
        data2.xAxisData = ["8:00", "9:00", "10.00", "11:00", "12:00", "13:00", "14:00"]
        data2.lineColor = color2
        
        var data3 = CTChartViewData()
        data3.name = "影响占比"
        data3.yAxis = .none
        data3.unit = "%"
        data3.yAxisMax = 100
        data3.yAxisData = [82, 31, 100, 45, 36, 42, 66]
        data3.xAxisData = ["8:00", "9:00", "10.00", "11:00", "12:00", "13:00", "14:00"]
        data3.lineColor = color3
        
        chartView.data = [data1, data2, data3]
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
