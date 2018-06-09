//
//  DatePickerDemoViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/5/29.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class DatePickerDemoViewController: PeekViewController {

    @IBOutlet weak var buttonAll: UIButton!
    @IBOutlet weak var buttonYMD: UIButton!
    @IBOutlet weak var buttonHMS: UIButton!
    @IBOutlet weak var buttonYMDHM: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action on button
    @IBAction func onButtonAllAction(_ sender: Any) {
        let datePicker = DatePickerView.datePicker(style: .all, scrollToDate: Date()) { date in
            guard let date = date else { return }
            
            let dateStr = date.toString("yyyy-MM-dd HH:mm:ss")
            self.buttonAll.setTitle(dateStr, for: .normal)
        }
        
        let date = Date.date(buttonAll.currentTitle!, formatter: "yyyy-MM-dd HH:mm:ss")
        datePicker.scrollToDate = date == nil ? Date() : date!
        
        datePicker.show()
    }
    
    @IBAction func onButtonYMDAction(_ sender: Any) {
        let datePicker = DatePickerView.datePicker(style: .yearMonthDay, scrollToDate: Date()) { date in
            guard let date = date else { return }
            
            let dateStr = date.toString("yyyy-MM-dd")
            self.buttonYMD.setTitle(dateStr, for: .normal)
        }
        
        let date = Date.date(buttonYMD.currentTitle!, formatter: "yyyy-MM-dd")
        datePicker.scrollToDate = date == nil ? Date() : date!
        
        datePicker.show()
    }
    
    @IBAction func onButtonHMSAction(_ sender: Any) {
        let datePicker = DatePickerView.datePicker(style: .hourMinuteSecond, scrollToDate: Date()) { date in
            guard let date = date else { return }
            
            let dateStr = date.toString("HH:mm:ss")
            self.buttonHMS.setTitle(dateStr, for: .normal)
        }
        
        let date = Date.date(buttonHMS.currentTitle!, formatter: "HH:mm:ss")
        datePicker.scrollToDate = date == nil ? Date() : date!
        
        datePicker.show()
    }
    
    @IBAction func onButtonYMDHMAction(_ sender: Any) {
        
        let dateFormatter = "yyyy-MM-dd HH:mm"
        
        let datePicker = DatePickerView.datePicker(style: .yearMonthDayHourMinute, scrollToDate: Date()) { date in
            guard let date = date else { return }
            
            let dateStr = date.toString(dateFormatter)
            self.buttonYMDHM.setTitle(dateStr, for: .normal)
        }
        
        let date = Date.date(buttonYMDHM.currentTitle!, formatter: dateFormatter)
        
        if let date = Date.date("2000-01-01 00:00", formatter: dateFormatter) {
            datePicker.minLimitDate = date
        }
        
        if let date = Date.date("2050-01-05 18:18", formatter: dateFormatter) {
            datePicker.maxLimitDate = date
        }
        
        datePicker.scrollToDate = date == nil ? Date() : date!
        
        datePicker.show()
    }
    
}


