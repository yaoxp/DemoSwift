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
    
    @IBOutlet weak var barGraph: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drawCurveChart()
        drawBarChart()
    }
    
    func drawBarChart() {
        let chartView = CTChartView.loadViewFromNib()
        chartView.type = .bar
        chartView.isShowBottomButtons = false
        barGraph.addSubview(chartView)
        chartView.xAxisData = ["江苏", "上海", "安徽", "浙江", "北京"]
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        var data1 = CTChartViewData()
        data1.name = "异常次数"
        data1.yAxis = .left
        data1.yAxisData = [723, 821, 19, 456, 765]
        data1.lineColor = color1
        
        var data2 = CTChartViewData()
        data2.name = "异常人次"
        data2.yAxis = .right
        data2.yAxisData = [234, 421, 159, 756, 1000]
        data2.lineColor = color2

        chartView.extensionInfo = [["阻塞" : ["1", "2", "3", "4", "5"]],
                                   ["严重" : ["10", "20", "30", "40", "50"]],
                                   ["一般" : ["11", "21", "31", "41", "51"]],
                                   ["无影响" : ["12", "22", "32", "42", "52"]]]
        
        chartView.data = [data1, data2]
    }

    func drawCurveChart() {
        let chartView = CTChartView.loadViewFromNib()
        cellView.addSubview(chartView)
//        chartView.xAxisData = ["0:00"]
        chartView.xAxisData = ["0:00", "1:00", "2.00", "3:00", "4:00", "5:00", "6:00", "7:00", "8.00", "9:00", "10:00", "11:00"]
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        var data1 = CTChartViewData()
        data1.name = "男性"
        data1.yAxis = .left
//        data1.yAxisData = [723]
        data1.yAxisData = [723, 821, 19, 456, 765, 423, 666, 234, 567, 124, 890, 711]
        data1.lineColor = color1
        
        var data2 = CTChartViewData()
        data2.name = "女性"
        data2.yAxis = .right
//        data2.yAxisData = [234]
        data2.yAxisData = [234, 421, 159, 756, 1000, 523, 266, 098, 456, 528, 109, 199]
        data2.lineColor = color2
        
        var data3 = CTChartViewData()
        data3.name = "中年人占比"
        data3.yAxis = .none
        data3.unit = "%"
        data3.yAxisMax = 100
//        data3.yAxisData = [82]
        data3.yAxisData = [82, 31.4, 100, 45.1, 36.8, -42, 66, 45.2, 68.4, 90, 90.3, 29.8]
        data3.lineColor = color3
        
        chartView.data = [data1, data2, data3]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onScrollChartButton(_ sender: Any) {
        let vc = CTScrollChartDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
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
