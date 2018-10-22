//
//  OffScreenViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/10/19.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class OffScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        let button0 = UIButton(type: .system)
        button0.tag = 0
        if let cellType = CustomCellRenderType(rawValue: 0) {
            button0.setTitle(cellType.description, for: .normal)
        }
        button0.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)
        
        let button1 = UIButton(type: .system)
        button1.tag = 1
        if let cellType = CustomCellRenderType(rawValue: 1) {
            button1.setTitle(cellType.description, for: .normal)
        }
        button1.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)
        
        let button2 = UIButton(type: .system)
        button2.tag = 2
        if let cellType = CustomCellRenderType(rawValue: 2) {
            button2.setTitle(cellType.description, for: .normal)
        }
        button2.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)
        
        let button3 = UIButton(type: .system)
        button3.tag = 3
        if let cellType = CustomCellRenderType(rawValue: 3) {
            button3.setTitle(cellType.description, for: .normal)
        }
        button3.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)
        
        view.addSubview(button0)
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        button0.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.centerY.equalToSuperview().offset(-89)
            $0.height.equalTo(22)
        }
        
        button1.snp.makeConstraints {
            $0.centerX.width.height.equalTo(button0)
            $0.top.equalTo(button0.snp.bottom).offset(30)
        }
        
        button2.snp.makeConstraints {
            $0.centerX.width.height.equalTo(button0)
            $0.top.equalTo(button1.snp.bottom).offset(30)
        }
        
        button3.snp.makeConstraints {
            $0.centerX.width.height.equalTo(button0)
            $0.top.equalTo(button2.snp.bottom).offset(30)
        }
    }
    
    @objc func onButtonAction(sender: UIButton) {
        let vc = OffScreenTableViewController()
        
        if let cellType = CustomCellRenderType(rawValue: sender.tag) {
            vc.cellType = cellType
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}

