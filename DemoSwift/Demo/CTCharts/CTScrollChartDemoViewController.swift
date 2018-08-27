//
//  CTScrollChartDemoViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/8/23.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class CTScrollChartDemoViewController: UIViewController {
    @IBOutlet weak var midView: UIView!
    
    private let scrollChartView = CTScrollBarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        // Do any additional setup after loading the view.
        setupScrollChartView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScrollChartView() {
        midView.addSubview(scrollChartView)
        scrollChartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        var data = CTScrollBarChartViewData()
        let dateFormatter = "yyyy-MM-dd HH:mm:ss"
        data.startTime = Date.date("2018-08-23 00:00:00", formatter: dateFormatter)!
        data.endTime = Date.date("2018-08-23 23:59:59", formatter: dateFormatter)!
        
        var data1 = CTScrollBarChartPointInfo()
        data1.startTime = Date.date("2018-08-23 08:00:00", formatter: dateFormatter)!
        data1.endTime = Date.date("2018-08-23 08:30:00", formatter: dateFormatter)!
        data1.number = 123
        data1.extensionInfo = ["异常次数：123", "阻塞：100", "无影响：23"]
        
        var data2 = CTScrollBarChartPointInfo()
        data2.startTime = Date.date("2018-08-23 12:23:18", formatter: dateFormatter)!
        data2.endTime = Date.date("2018-08-23 13:10:50", formatter: dateFormatter)!
        data2.number = 223
        data2.extensionInfo = ["异常次数：223", "阻塞：100","严重：100", "无影响：23"]
        
        var data3 = CTScrollBarChartPointInfo()
        data3.startTime = Date.date("2018-08-23 18:00:00", formatter: dateFormatter)!
        data3.endTime = Date.date("2018-08-23 18:10:35", formatter: dateFormatter)!
        data3.number = 30
        data3.extensionInfo = ["异常次数：30", "阻塞：9", "无影响：21"]
        
        var data4 = CTScrollBarChartPointInfo()
        data4.startTime = Date.date("2018-08-23 20:00:00", formatter: dateFormatter)!
        data4.endTime = Date.date("2018-08-23 20:08:10", formatter: dateFormatter)!
        data4.number = 93
        data4.extensionInfo = ["异常次数：93", "一般：10", "无影响：83"]
        
        var data5 = CTScrollBarChartPointInfo()
        data5.startTime = Date.date("2018-08-23 22:00:00", formatter: dateFormatter)!
        data5.endTime = Date.date("2018-08-23 22:15:00", formatter: dateFormatter)!
        data5.number = 53
        data5.extensionInfo = ["异常次数：53", "阻塞：30", "无影响：23"]
        
        data.yAxisData = [data1, data2, data3, data4, data5]
        scrollChartView.data = data
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
