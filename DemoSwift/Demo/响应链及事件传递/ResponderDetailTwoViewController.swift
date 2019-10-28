//
//  ResponderDetailTwoViewController.swift
//  DemoSwift
//
//  Created by jiangnan on 2019/10/28.
//  Copyright © 2019 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class CustomView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("\(self.backgroundColor!.colorName) in")
        if let view = super.hitTest(point, with: event) {
            print("\(self.backgroundColor!.colorName) out: return \(view.backgroundColor!.colorName)")
            return view
        }
        print("\(self.backgroundColor!.colorName) out: return nil")
        return nil
    }
}

class ResponderDetailTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK: - UI
    func initUI() {
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        whiteView.addSubview(redView)
        whiteView.addSubview(greenView)
        whiteView.addSubview(yellowView)
        redView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        greenView.snp.makeConstraints {
            $0.center.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        yellowView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
        greenView.addSubview(blueView)
        greenView.addSubview(blackView)
        blueView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.trailing.equalTo(greenView.snp.centerX).offset(-20)
        }
        blackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalTo(greenView.snp.centerX).offset(20)
        }
    }
    
// MARK: -property
    let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        return view
    }()
    let blackView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .black
        return view
    }()
    let redView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .red
        return view
    }()
    let greenView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .green
        return view
    }()
    let yellowView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .yellow
        return view
    }()
    let blueView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .blue
        return view
    }()

}

// MARK: - color name
fileprivate extension UIColor {
    var colorName: String {
        switch self {
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .yellow:
            return "Yellow"
        case .blue:
            return "Blue"
        case .black:
            return "Black"
        case .white:
            return "White"
        default:
            return "Other"
        }
    }
}
