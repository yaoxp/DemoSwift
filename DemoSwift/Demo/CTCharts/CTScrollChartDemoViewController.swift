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
        
        let scrollChartView = CTScrollBarTimeChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 205))
        midView.addSubview(scrollChartView)
        
        var data = CTScrollBarTimeChartViewData()
        let dateFormatter = "yyyy-MM-dd HH:mm:ss"
        data.startTime = Date.date("2018-08-23 00:00:00", formatter: dateFormatter)!
//        data.startTime = Date.date("2018-08-23 00:10:00", formatter: dateFormatter)!
        data.endTime = Date.date("2018-08-23 23:59:59", formatter: dateFormatter)!
        
        var data0 = CTScrollBarTimeChartPointInfo()
        data0.startTime = Date.date("2018-08-23 00:10:00", formatter: dateFormatter)!
        data0.endTime = Date.date("2018-08-23 00:30:00", formatter: dateFormatter)!
        data0.number = 223
        data0.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data1 = CTScrollBarTimeChartPointInfo()
        data1.startTime = Date.date("2018-08-23 08:00:00", formatter: dateFormatter)!
        data1.endTime = Date.date("2018-08-23 08:30:00", formatter: dateFormatter)!
        data1.number = 123
        data1.extensionInfo = ["异常次数：123", "阻塞：100", "无影响：23"]
        
        var data2 = CTScrollBarTimeChartPointInfo()
        data2.startTime = Date.date("2018-08-23 12:23:18", formatter: dateFormatter)!
        data2.endTime = Date.date("2018-08-23 13:10:50", formatter: dateFormatter)!
        data2.number = 223
        data2.extensionInfo = ["异常次数：223", "阻塞：100","严重：100", "无影响：23"]
        
        var data3 = CTScrollBarTimeChartPointInfo()
        data3.startTime = Date.date("2018-08-23 18:00:00", formatter: dateFormatter)!
        data3.endTime = Date.date("2018-08-23 18:10:35", formatter: dateFormatter)!
        data3.number = 30
        data3.extensionInfo = ["异常次数：30", "阻塞：9", "无影响：21"]
        
        var data4 = CTScrollBarTimeChartPointInfo()
        data4.startTime = Date.date("2018-08-23 20:00:00", formatter: dateFormatter)!
        data4.endTime = Date.date("2018-08-23 20:08:10", formatter: dateFormatter)!
        data4.number = 93
        data4.extensionInfo = ["异常次数：93", "一般：10", "无影响：83"]
        
        var data5 = CTScrollBarTimeChartPointInfo()
        data5.startTime = Date.date("2018-08-23 22:00:00", formatter: dateFormatter)!
        data5.endTime = Date.date("2018-08-23 22:15:00", formatter: dateFormatter)!
        data5.number = 53
        data5.extensionInfo = ["异常次数：53", "阻塞：30", "无影响：23"]
        
        var data6 = CTScrollBarTimeChartPointInfo()
        data6.startTime = Date.date("2018-08-23 22:21:00", formatter: dateFormatter)!
        data6.endTime = Date.date("2018-08-23 22:28:00", formatter: dateFormatter)!
        data6.number = 58
        data6.extensionInfo = ["异常次数：58", "阻塞：35", "无影响：23"]
        
        var data7 = CTScrollBarTimeChartPointInfo()
        data7.startTime = Date.date("2018-08-23 22:34:00", formatter: dateFormatter)!
        data7.endTime = Date.date("2018-08-23 22:45:00", formatter: dateFormatter)!
        data7.number = 18
        data7.extensionInfo = ["异常次数：18", "阻塞：15", "无影响：3"]
        
        data.yAxisData = [data0, data1, data2, data3, data4, data5, data6, data7]
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
