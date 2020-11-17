//
//  MarqueeView.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/5/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

enum MarqueeDirection {
    case left
    case right
}

// MARK: - 初始化
class MarqueeView: UIView {

    var direction: MarqueeDirection = .left
    var contentView: UIView? {
        didSet {
            self.setNeedsLayout()
        }
    }
    /// 视图每秒刷新60次，刷新几次更新一次视图位置
    var frameInterval: Int = 2

    /// 每次刷新移动的长度.每秒移动的长度 =  60 / frameInterval * pointsPerFrame
    var pointsPerFrame: CGFloat = 0.5

    private var displayLink: CADisplayLink?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = UIColor.clear
        clipsToBounds = true
    }

    deinit {

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let validContentView = contentView else { return }

        for view in subviews {
            view.removeFromSuperview()
        }

        validContentView.sizeToFit()
        addSubview(validContentView)

        // 往左滚动时左对齐，往右滚动时右对齐
        switch direction {
        case .left:
            validContentView.frame = CGRect(origin: .zero, size: validContentView.frame.size)
        default:
            validContentView.frame = CGRect(origin: CGPoint(x: self.frame.size.width - validContentView.frame.size.width, y: 0), size: validContentView.frame.size)

        }
    }
}

// MARK: - 对外接口
extension MarqueeView {
    func startAnimation() {
        if let link = displayLink {
            link.invalidate()
        }

        guard contentView != nil else { return }

        displayLink = CADisplayLink(target: self, selector: #selector(processMarquee))
        if let link = displayLink {
            if #available(iOS 10, *) {
                link.preferredFramesPerSecond = 60 / frameInterval
            } else {
                link.frameInterval = frameInterval
            }
            link.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        }
    }

    func pauseAnimation() {
        if let link = displayLink {
            link.isPaused = true
        }
    }

    func restartAnimation() {
        if let link = displayLink {
            link.isPaused = false
        }
    }

    func stopAnimation() {
        if let link = displayLink {
            link.invalidate()
            self.displayLink = nil
        }
    }
}

// MARK: - 私有接口
extension MarqueeView {
    @objc func processMarquee() {

        guard let view = contentView else { return }
        guard view.frame.size.width > self.frame.size.width else { return }

        switch direction {
        case .left:
            if (view.frame.origin.x + view.frame.size.width) <= 0 {
                // 滚动到末尾
                view.frame = CGRect(origin: CGPoint(x: self.frame.size.width, y: 0), size: view.frame.size)
            } else {
                view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x - pointsPerFrame, y: 0), size: view.frame.size)
            }
        case .right:
            if view.frame.origin.x >= self.frame.size.width {
                // 滚动到末尾
                view.frame = CGRect(origin: CGPoint(x: 0 - view.frame.size.width, y: 0), size: view.frame.size)
            } else {
                view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x + pointsPerFrame, y: 0), size: view.frame.size)
            }
        }
    }

}
