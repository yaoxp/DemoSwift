//
//  MarqueeViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/5/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class MarqueeViewController: PeekViewController {
    
    var left: MarqueeView?
    var right: MarqueeView?
    var blend: MarqueeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.lightGray
        
        // MARK: - 文本，向左滚动
        let leftText = UILabel()
        leftText.text = "abcdefghijklmnopqrstuvwxyz"
        
        let leftMarqueeText = MarqueeView.init(frame: .zero)
        leftMarqueeText.contentView = leftText
        leftMarqueeText.backgroundColor = UIColor.yellow
        
        view.addSubview(leftMarqueeText)
        leftMarqueeText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.width.equalTo(100)
            $0.height.equalTo(20)
        }
        leftMarqueeText.startAnimation()
        
        // MARK: - 文本，向右滚动
        let rightText = UILabel()
        rightText.text = "abcdefghijklmnopqrstuvwxyz"
        let rightMarqueeText = MarqueeView.init(frame: .zero)
        rightMarqueeText.contentView = rightText
        rightMarqueeText.backgroundColor = UIColor.yellow
        rightMarqueeText.direction = .right
        view.addSubview(rightMarqueeText)
        rightMarqueeText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(leftMarqueeText.snp.bottom).offset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(20)
        }
        rightMarqueeText.startAnimation()
        
        // MARK: - 文本图片混合滚动
        let label = UILabel()
        label.text = "abcde"
        label.sizeToFit()
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "PayTheBill_smallHeaderImg"))
        
        let label2 = UILabel()
        label2.text = "fghijklmn"
        label2.sizeToFit()
        
        let contentView = UIView()
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(label.frame.size.width)
        }
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(label.snp.trailing)
            $0.width.equalTo(20)
        }
        contentView.addSubview(label2)
        label2.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing)
            $0.width.equalTo(label2.frame.size.width)
            $0.trailing.equalToSuperview()
        }
        
        contentView.frame = CGRect(origin: .zero, size: CGSize(width: label.frame.size.width + 20 + label2.frame.size.width, height: 20))
        
        let marquee = MarqueeView(frame: .zero)
        marquee.contentView = contentView
        marquee.backgroundColor = UIColor.yellow
        view.addSubview(marquee)
        marquee.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(rightMarqueeText.snp.bottom).offset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(20)
        }
        marquee.startAnimation()
        
        left = leftMarqueeText
        right = rightMarqueeText
        blend = marquee
        
        
        let startBtn = UIButton(type: .system)
        startBtn.setTitle("start", for: .normal)
        startBtn.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        
        let stopBtn = UIButton(type: .system)
        stopBtn.setTitle("stop", for: .normal)
        stopBtn.addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)
        
        let pauseBtn = UIButton(type: .system)
        pauseBtn.setTitle("pause", for: .normal)
        pauseBtn.addTarget(self, action: #selector(pauseAnimation), for: .touchUpInside)
        
        let restartBtn = UIButton(type: .system)
        restartBtn.setTitle("restart", for: .normal)
        restartBtn.addTarget(self, action: #selector(restartAnimation), for: .touchUpInside)
        
        let stackView = UIStackView()
        stackView.alignment = UIStackView.Alignment.fill
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(startBtn)
        stackView.addArrangedSubview(pauseBtn)
        stackView.addArrangedSubview(restartBtn)
        stackView.addArrangedSubview(stopBtn)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-80)
            $0.height.equalTo(30)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func startAnimation() {
        left?.startAnimation()
        right?.startAnimation()
        blend?.startAnimation()
    }
    
    @objc func stopAnimation() {
        left?.stopAnimation()
        right?.stopAnimation()
        blend?.stopAnimation()
    }
    
    @objc func pauseAnimation() {
        left?.pauseAnimation()
        right?.pauseAnimation()
        blend?.pauseAnimation()
    }
    
    @objc func restartAnimation() {
        left?.restartAnimation()
        right?.restartAnimation()
        blend?.restartAnimation()
    }

}
