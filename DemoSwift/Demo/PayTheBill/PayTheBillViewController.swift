//
//  PayTheBillViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/19.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class PayTheBillViewController: PeekViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopOffset: NSLayoutConstraint!
    
    private lazy var titleView = PayTheBillTitleView.loadViewFromNib()
    
    private lazy var headerView = PayTheBillHeaderView.loadViewFromNib()
    
    private var bInitRange = false
    private var yRange: CGFloat = 0   // y轴方向需要移动的距离
    private var xRange: CGFloat = 0   // x轴方向需要移动的距离
    private var originPoint = CGPoint(x: 0, y: 0) // 移动图片初始位置, 底线起点
    
    private let navigationBarBackgroundView: UIImageView = {
        let imgView = UIImageView(image: UIImage.createImage(color: UIColor.hexRGB(0x1E90FF)))
        return imgView
    }()
    
    var barShadowImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewTopOffset.constant = 0 - (UIApplication.shared.statusBarFrame.size.height + 44)
        tableView.contentInset = UIEdgeInsetsMake(0 - (UIApplication.shared.statusBarFrame.size.height + 44), 0, -44, 0)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PayTheBillViewControllerCell")
        // 设置titleview
        navigationItem.titleView = titleView
        titleView.headerImgView.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // preview时没有navigationController
        if let nc = navigationController {
            nc.navigationBar.insertSubview(navigationBarBackgroundView, at: 0)
            
            navigationBarBackgroundView.frame = CGRect(x: 0, y: 0 - UIApplication.shared.statusBarFrame.height, width: nc.navigationBar.bounds.size.width, height: nc.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.height)
            navigationBarBackgroundView.alpha = 0;
            
            barShadowImage = nc.navigationBar.shadowImage
            
            nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nc.navigationBar.shadowImage = UIImage()
            nc.navigationBar.isTranslucent = true
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if bInitRange == false {
            bInitRange = true
            
            let smallIconRect = titleView.convert(titleView.headerImgView.frame, to: nil)
            
            let bigIconRect = headerView.convert(headerView.iconImgView.frame, to: nil)
            
            // 底线起点
            originPoint = CGPoint(x: bigIconRect.origin.x, y: bigIconRect.origin.y + bigIconRect.size.height)
            
            // 底线起点的距离
            xRange = CGFloat(fabsf(Float(smallIconRect.origin.x - bigIconRect.origin.x)))
            
            yRange = CGFloat(fabsf(Float((smallIconRect.origin.y + smallIconRect.size.height) - (bigIconRect.origin.y + bigIconRect.size.height))))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let nc = navigationController {
            nc.navigationBar.setBackgroundImage(UIImage.createImage(color: UIColor.white), for: .default)
            nc.navigationBar.shadowImage = barShadowImage
            nc.navigationBar.isTranslucent = true
            navigationBarBackgroundView.removeFromSuperview()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UIScroll delegate

extension PayTheBillViewController {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard yRange > 0 else {
            return
        }

        if scrollView.contentOffset.y <= 0 {
            if headerView.imgViewHeightAndWidth.constant == 60 {
                
                return
            } else {
                headerView.imgViewHeightAndWidth.constant = 60
                headerView.imgViewLeading.constant = 15
                headerView.nameLabel.alpha = 1.0
                
                return
            }
        }
        
        let ratioY = scrollView.contentOffset.y / yRange // y轴上移动的百分比
        
        guard ratioY < 1 else {
            headerView.nameLabel.alpha = 0.0
            headerView.iconImgView.alpha = 0.0
            titleView.headerImgView.isHidden = false
            navigationBarBackgroundView.alpha = 1.0
            return
        }
        navigationBarBackgroundView.alpha = 0
        headerView.nameLabel.alpha = 1 - ratioY
        headerView.iconImgView.alpha = 1.0
        titleView.headerImgView.isHidden = true
        
        headerView.imgViewLeading.constant = 15 + xRange * ratioY
        headerView.imgViewHeightAndWidth.constant = 60 - 30 * ratioY
        
    }
}

// MARK: - UITableViewDelegate dataSource

extension PayTheBillViewController  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayTheBillViewControllerCell", for: indexPath)
        cell.textLabel?.text = "row \(indexPath.row)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice.isX() {
            return 180 + 24
        } else {
            return 180
        }
    }
}

