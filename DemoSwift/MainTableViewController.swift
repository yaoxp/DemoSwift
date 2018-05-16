//
//  MainTableViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    // MARK: - cell
    static let tableViewCellIdentifier = "MainTableCell"
    
    // MARK: - properties
    let demos = [Demo(title: "动画", subTitle: "贝塞尔曲线，优酷播放按钮，引导页跳过按钮，打卡按钮", className: NSStringFromClass(AnimationViewController.self)),
                 Demo(title: "买单吧", subTitle: "tableview上推，头像渐变到导航栏上", className: NSStringFromClass(PayTheBillViewController.self)),
                 Demo(title: "跑马灯", subTitle: "支持富文本和图片", className: NSStringFromClass(MarqueeViewController.self))]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
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
        cell.detailTextLabel!.text = demo.subTitle
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = demos[indexPath.row]
        
        if let vcClass = NSClassFromString(demo.className) as? UIViewController.Type {
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
}

// MARK: - UIViewControllerPreviewingDelegate
extension MainTableViewController {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let cellPoint = tableView.convert(location, from: previewingContext.sourceView)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPoint),
                let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        previewingContext.sourceRect = cell.frame
        
        let demo = demos[indexPath.row]
        if let vcClass = NSClassFromString(demo.className) as? UIViewController.Type {
            return vcClass.init()
        }

        return nil
    }
    
}
