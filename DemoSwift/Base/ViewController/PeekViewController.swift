//
//  PeekViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/5/16.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class PeekViewController: UIViewController {

    var indexPath: IndexPath?
    weak var previewActionDelegate: ThreeTouchPreviewActionDelegate?

    // 3D Touch peek 功能
    override open var previewActionItems: [UIPreviewActionItem] {
        // preview时上滑时下面出来的选择条目
        let setTop = UIPreviewAction(title: "置顶", style: .default, handler: { (action: UIPreviewAction, previewVC: UIViewController) in

            self.previewActionDelegate?.previewAction(setTop: self.indexPath)
        })

        let delete = UIPreviewAction(title: "删除", style: .destructive) { _, _ in
            self.previewActionDelegate?.previewAction(delete: self.indexPath)
        }

        return [setTop, delete]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
