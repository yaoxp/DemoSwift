//
//  CTScrollChartDemoViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/8/23.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class CTScrollChartDemoViewController: UIViewController {
    /// X轴是时间轴，柱子在的位置要体现时间点
    @IBOutlet weak var midView: UIView!
    /// X轴是时间轴，柱子在的位置和时间无关，等间距
    @IBOutlet weak var scrollChartSupView: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        // Do any additional setup after loading the view.
        setupScrollTimeChartView()
        setupScrollChartView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScrollTimeChartView() {
        
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
    
    func setupScrollChartView() {
        
        let scrollChartView = CTScrollBarChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 205))
        scrollChartSupView.addSubview(scrollChartView)
        
        var data = CTScrollBarChartViewData()
        let dateFormatter = "yyyy-MM-dd HH:mm:ss"
        data.startTime = Date.date("2018-08-23 00:00:00", formatter: dateFormatter)!
        //        data.startTime = Date.date("2018-08-23 00:10:00", formatter: dateFormatter)!
        data.endTime = Date.date("2018-08-23 23:59:59", formatter: dateFormatter)!
        
        var data0 = CTScrollBarChartPointInfo()
        data0.startTime = Date.date("2018-08-23 00:10:00", formatter: dateFormatter)!
        data0.endTime = Date.date("2018-08-23 00:30:00", formatter: dateFormatter)!
        data0.number = 223
        data0.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data01 = CTScrollBarChartPointInfo()
        data01.startTime = Date.date("2018-08-23 00:40:00", formatter: dateFormatter)!
        data01.endTime = Date.date("2018-08-23 00:50:00", formatter: dateFormatter)!
        data01.number = 223
        data01.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data02 = CTScrollBarChartPointInfo()
        data02.startTime = Date.date("2018-08-23 01:00:00", formatter: dateFormatter)!
        data02.endTime = Date.date("2018-08-23 01:10:00", formatter: dateFormatter)!
        data02.number = 223
        data02.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data03 = CTScrollBarChartPointInfo()
        data03.startTime = Date.date("2018-08-23 01:10:00", formatter: dateFormatter)!
        data03.endTime = Date.date("2018-08-23 01:30:00", formatter: dateFormatter)!
        data03.number = 223
        data03.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data04 = CTScrollBarChartPointInfo()
        data04.startTime = Date.date("2018-08-23 02:10:00", formatter: dateFormatter)!
        data04.endTime = Date.date("2018-08-23 02:30:00", formatter: dateFormatter)!
        data04.number = 223
        data04.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data05 = CTScrollBarChartPointInfo()
        data05.startTime = Date.date("2018-08-23 03:10:00", formatter: dateFormatter)!
        data05.endTime = Date.date("2018-08-23 03:30:00", formatter: dateFormatter)!
        data05.number = 223
        data05.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data06 = CTScrollBarChartPointInfo()
        data06.startTime = Date.date("2018-08-23 04:10:00", formatter: dateFormatter)!
        data06.endTime = Date.date("2018-08-23 04:30:00", formatter: dateFormatter)!
        data06.number = 223
        data06.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data07 = CTScrollBarChartPointInfo()
        data07.startTime = Date.date("2018-08-23 05:10:00", formatter: dateFormatter)!
        data07.endTime = Date.date("2018-08-23 05:30:00", formatter: dateFormatter)!
        data07.number = 223
        data07.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data08 = CTScrollBarChartPointInfo()
        data08.startTime = Date.date("2018-08-23 06:10:00", formatter: dateFormatter)!
        data08.endTime = Date.date("2018-08-23 06:30:00", formatter: dateFormatter)!
        data08.number = 223
        data08.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data09 = CTScrollBarChartPointInfo()
        data09.startTime = Date.date("2018-08-23 07:10:00", formatter: dateFormatter)!
        data09.endTime = Date.date("2018-08-23 07:30:00", formatter: dateFormatter)!
        data09.number = 223
        data09.extensionInfo = ["异常次数：223", "阻塞：100", "无影响：123"]
        
        var data1 = CTScrollBarChartPointInfo()
        data1.startTime = Date.date("2018-08-23 08:00:00", formatter: dateFormatter)!
        data1.endTime = Date.date("2018-08-23 08:30:00", formatter: dateFormatter)!
        data1.number = 123
        data1.extensionInfo = ["异常次数：123", "阻塞：100", "无影响：23"]
        
        var data10 = CTScrollBarChartPointInfo()
        data10.startTime = Date.date("2018-08-23 09:00:00", formatter: dateFormatter)!
        data10.endTime = Date.date("2018-08-23 09:30:00", formatter: dateFormatter)!
        data10.number = 123
        data10.extensionInfo = ["异常次数：123", "阻塞：100", "无影响：23"]
        
        var data11 = CTScrollBarChartPointInfo()
        data11.startTime = Date.date("2018-08-23 09:40:00", formatter: dateFormatter)!
        data11.endTime = Date.date("2018-08-23 09:50:00", formatter: dateFormatter)!
        data11.number = 123
        data11.extensionInfo = ["异常次数：123", "阻塞：100", "无影响：23"]
        
        var data12 = CTScrollBarChartPointInfo()
        data12.startTime = Date.date("2018-08-23 10:00:00", formatter: dateFormatter)!
        data12.endTime = Date.date("2018-08-23 10:10:00", formatter: dateFormatter)!
        data12.number = 123
        data12.extensionInfo = ["异常次数：123", "阻塞：100", "无影响：23"]
        
        var data13 = CTScrollBarChartPointInfo()
        data13.startTime = Date.date("2018-08-23 10:20:00", formatter: dateFormatter)!
        data13.endTime = Date.date("2018-08-23 10:30:00", formatter: dateFormatter)!
        data13.number = 123
        data13.extensionInfo = ["异常次数：123", "阻塞：100", "无影响：23"]
        
        var data14 = CTScrollBarChartPointInfo()
        data14.startTime = Date.date("2018-08-23 11:40:00", formatter: dateFormatter)!
        data14.endTime = Date.date("2018-08-23 12:00:00", formatter: dateFormatter)!
        data14.number = 123
        data14.extensionInfo = ["异常次数：123", "阻塞：100", "无影响：23"]
        
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
        
        var data6 = CTScrollBarChartPointInfo()
        data6.startTime = Date.date("2018-08-23 22:21:00", formatter: dateFormatter)!
        data6.endTime = Date.date("2018-08-23 22:28:00", formatter: dateFormatter)!
        data6.number = 58
        data6.extensionInfo = ["异常次数：58", "阻塞：35", "无影响：23"]
        
        var data7 = CTScrollBarChartPointInfo()
        data7.startTime = Date.date("2018-08-23 22:34:00", formatter: dateFormatter)!
        data7.endTime = Date.date("2018-08-23 22:45:00", formatter: dateFormatter)!
        data7.number = 18
        data7.extensionInfo = ["异常次数：18", "阻塞：15", "无影响：3"]
        
        data.yAxisData = [data0, data01, data02, data03, data04, data05, data06, data07, data08, data09,  data1, data10, data11, data12, data13, data14, data2, data3, data4, data5, data6, data7]
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
