//
//  MainTableViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, ThreeTouchPreviewActionDelegate {
    // MARK: - cell
    static let tableViewCellIdentifier = "MainTableCell"

    // MARK: - properties
    var demos = [Demo(title: "动画",
                      subtitle: "贝塞尔曲线，优酷播放按钮，引导页跳过按钮，打卡按钮",
                      class: AnimationViewController.self),
                 Demo(title: "买单吧",
                      subtitle: "tableview上推，头像渐变到导航栏上",
                      class: PayTheBillViewController.self),
                 Demo(title: "跑马灯",
                      subtitle: "支持富文本和图片",
                      class: MarqueeViewController.self),
                 Demo(title: "日期选择器",
                      subtitle: "支持配置显示内容，背景水印",
                      class: DatePickerDemoViewController.self),
                 Demo(title: "包含 Bundle 资源的 framework",
                      subtitle: "主要看代码",
                      class: DynamicAndStaticViewController.self),
                 Demo(title: "双Y轴表格",
                      subtitle: "主要看代码",
                      class: CTChartDemoViewController.self),
                 Demo(title: "大图片缩小处理",
                      subtitle: "对高精度图片的缩略对比",
                      class: BigImageTableViewController.self)]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(headerNotification), name: Notification.Name("animation"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewController.tableViewCellIdentifier, for: indexPath)

        // Configure the cell...
        let demo = demos[indexPath.row]
        cell.textLabel!.text = demo.title
        cell.detailTextLabel!.text = demo.subtitle
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = demos[indexPath.row]
        
        if let vcClass = demo.class as? UIViewController.Type {
            let vc = vcClass.init()
            navigationController!.pushViewController(vc, animated: true)
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    @objc func headerNotification(notification: Notification) {
//        let vc = AnimationViewController()
//        show(vc, sender: self)
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension MainTableViewController {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // 跳转到预览的viewController
        show(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // previewingContext.sourceView 注册preview的view。本demo中是self.view
        // registerForPreviewing(with: self, sourceView: view)
        let cellPoint = tableView.convert(location, from: previewingContext.sourceView)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPoint),
                let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        // 不模糊的区域，其它区域会模糊处理。微信QQ都有此功能
        previewingContext.sourceRect = cell.frame
        
        let demo = demos[indexPath.row]
        if let vcClass = demo.class as? PeekViewController.Type {
            let vc = vcClass.init()
            vc.previewActionDelegate = self
            vc.indexPath = indexPath
            return vc
        }
        
        return nil
    }
    
}

// MARK: - ThreeTouchPreviewActionDelegate
extension MainTableViewController {
    func previewAction(setTop index: IndexPath?) {
        guard index != nil && index!.row < demos.count else { return }
        
        demos.insert(demos.remove(at: index!.row), at: 0)
        tableView.reloadData()
    }
    
    func previewAction(delete index: IndexPath?) {
        guard index != nil && index!.row < demos.count else { return }
        
        demos.remove(at: index!.row)
        tableView.reloadData()
    }
}
