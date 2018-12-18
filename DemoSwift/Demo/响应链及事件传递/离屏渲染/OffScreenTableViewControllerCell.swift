//
//  OffScreenTableViewControllerCell.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/10/22.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit

enum CustomCellRenderType: Int {
    case CornerRadiusOffScreenRender = 0
    case CornerRadiusOnScreenRender = 1
    case ShadowOffScreenRender = 2
    case ShadowOnScreenRender = 3
    
    var description: String {
        switch self {
        case .CornerRadiusOffScreenRender:
            return "圆角-离屏渲染"
        case .CornerRadiusOnScreenRender:
            return "圆角-非离屏渲染"
        case .ShadowOffScreenRender:
            return "阴影-离屏渲染"
        case .ShadowOnScreenRender:
            return "阴影-非离屏渲染"
        }
    }
}

class OffScreenTableViewControllerCell: UITableViewCell {

    lazy var shadowView1 = UIView()
    lazy var shadowView2 = UIView()
    lazy var cornerLabel1 = UILabel()
    lazy var cornerLabel2 = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(renderType: CustomCellRenderType) {
        switch renderType {
        case .CornerRadiusOffScreenRender:
            cornerLabel1.text = "abc";
            cornerLabel1.frame = CGRect(x: 100, y: 10, width: 30, height: 20)
            cornerLabel1.textColor = UIColor.black
            cornerLabel1.textAlignment = .center
            cornerLabel1.layer.cornerRadius = 5
            cornerLabel1.layer.borderColor = UIColor.green.cgColor
            cornerLabel1.layer.borderWidth = 1
            cornerLabel1.layer.masksToBounds = true
            contentView.addSubview(cornerLabel1)
            
            cornerLabel2.text = "abc";
            cornerLabel2.frame = CGRect(x: 200, y: 10, width: 30, height: 20)
            cornerLabel2.textColor = UIColor.black
            cornerLabel2.textAlignment = .center
            cornerLabel2.layer.cornerRadius = 5
            cornerLabel2.layer.borderColor = UIColor.green.cgColor
            cornerLabel2.layer.borderWidth = 1
            cornerLabel2.layer.masksToBounds = true
            contentView.addSubview(cornerLabel2)
        case .CornerRadiusOnScreenRender:
            cornerLabel1.text = "abc";
            cornerLabel1.frame = CGRect(x: 100, y: 10, width: 30, height: 20)
            cornerLabel1.textColor = UIColor.black
            cornerLabel1.textAlignment = .center
            cornerLabel1.layer.cornerRadius = 5
            cornerLabel1.layer.borderColor = UIColor.green.cgColor
            cornerLabel1.layer.borderWidth = 1
            contentView.addSubview(cornerLabel1)
            
            cornerLabel2.text = "abc";
            cornerLabel2.frame = CGRect(x: 200, y: 10, width: 30, height: 20)
            cornerLabel2.textColor = UIColor.black
            cornerLabel2.textAlignment = .center
            cornerLabel2.layer.cornerRadius = 5
            cornerLabel2.layer.borderColor = UIColor.green.cgColor
            cornerLabel2.layer.borderWidth = 1
            contentView.addSubview(cornerLabel2)
        case .ShadowOffScreenRender:
            shadowView1.frame = CGRect(x: 100, y: 10, width: 30, height: 20)
            shadowView1.layer.backgroundColor = UIColor.green.cgColor
            shadowView1.layer.shadowColor = UIColor.black.cgColor
            shadowView1.layer.shadowOpacity = 0.5
            shadowView1.layer.shadowRadius = 5
            shadowView1.layer.shadowOffset = CGSize(width: 5, height: 5)
            contentView.addSubview(shadowView1)
            
            shadowView2.frame = CGRect(x: 200, y: 10, width: 30, height: 20)
            shadowView2.layer.backgroundColor = UIColor.green.cgColor
            shadowView2.layer.shadowColor = UIColor.black.cgColor
            shadowView2.layer.shadowOpacity = 0.5
            shadowView2.layer.shadowRadius = 5
            shadowView2.layer.shadowOffset = CGSize(width: 5, height: 5)
            contentView.addSubview(shadowView2)
        case .ShadowOnScreenRender:
            shadowView1.frame = CGRect(x: 100, y: 10, width: 30, height: 20)
            shadowView1.layer.backgroundColor = UIColor.green.cgColor
            shadowView1.layer.shadowColor = UIColor.black.cgColor
            shadowView1.layer.shadowOpacity = 0.5
            shadowView1.layer.shadowRadius = 5
            shadowView1.layer.shadowOffset = CGSize(width: 5, height: 5)
            shadowView1.layer.shadowPath = UIBezierPath(rect: shadowView1.bounds).cgPath
            contentView.addSubview(shadowView1)
            
            shadowView2.frame = CGRect(x: 200, y: 10, width: 30, height: 20)
            shadowView2.layer.backgroundColor = UIColor.green.cgColor
            shadowView2.layer.shadowColor = UIColor.black.cgColor
            shadowView2.layer.shadowOpacity = 0.5
            shadowView2.layer.shadowRadius = 5
            shadowView2.layer.shadowOffset = CGSize(width: 5, height: 5)
            shadowView2.layer.shadowPath = UIBezierPath(rect: shadowView2.bounds).cgPath
            contentView.addSubview(shadowView2)

        }
    }

}
