//
//  NetworkDependDemovc.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/11/28.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit


class NetworkDependDemovc: UIViewController {
    
    let commonBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("common", for: .normal)
        return button
    }()
    
    let dispatchGroup1Btn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("group 1", for: .normal)
        return button
    }()
    
    let dispatchGroup2Btn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("group 2", for: .normal)
        return button
    }()
    
    let semaphoreBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("semaphore", for: .normal)
        return button
    }()
    
    let successBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("success", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(commonBtn)
        commonBtn.addTarget(self, action: #selector(common), for: .touchUpInside)
        commonBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.top.equalToSuperview().offset(100)
        }
        
        view.addSubview(dispatchGroup1Btn)
        dispatchGroup1Btn.addTarget(self, action: #selector(groupOne), for: .touchUpInside)
        dispatchGroup1Btn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.top.equalTo(commonBtn.snp.bottom).offset(30)
        }
        
        view.addSubview(dispatchGroup2Btn)
        dispatchGroup2Btn.addTarget(self, action: #selector(groupTwo), for: .touchUpInside)
        dispatchGroup2Btn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.top.equalTo(dispatchGroup1Btn.snp.bottom).offset(30)
        }
        
        view.addSubview(semaphoreBtn)
        semaphoreBtn.addTarget(self, action: #selector(semaphore), for: .touchUpInside)
        semaphoreBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.top.equalTo(dispatchGroup2Btn.snp.bottom).offset(30)
        }
        
        view.addSubview(successBtn)
        successBtn.addTarget(self, action: #selector(success), for: .touchUpInside)
        successBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.top.equalTo(semaphoreBtn.snp.bottom).offset(30)
        }
    }
    
    
    
    @objc func common() {
        print("\n=== begin ===")
        simulate(index: 1)
        simulate(index: 2)
        simulate(index: 3)
        simulate(index: 4)
        simulate(index: 5)
        simulate(index: 6)
        simulate(index: 7)
        simulate(index: 8)
        simulate(index: 9)
        simulate(index: 10)
        print("=== end ===\n")
    }
    
    @objc func groupOne() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "dispatchGroup")
        print("\n=== begin ===")
        queue.async(group: group) { self.simulate(index: 1) }
        queue.async(group: group) { self.simulate(index: 2) }
        queue.async(group: group) { self.simulate(index: 3) }
        queue.async(group: group) { self.simulate(index: 4) }
        queue.async(group: group) { self.simulate(index: 5) }
        queue.async(group: group) { self.simulate(index: 6) }
        queue.async(group: group) { self.simulate(index: 7) }
        queue.async(group: group) { self.simulate(index: 8) }
        queue.async(group: group) { self.simulate(index: 9) }
        queue.async(group: group) { self.simulate(index: 10) }
        
        group.notify(queue: DispatchQueue.main) { print("=== end ===\n") }
    }
    
    @objc func groupTwo() {
        let group = DispatchGroup()
        
        print("\n=== begin ===")
        
        for index in (1...10) {
            group.enter()
            print("已经发送 \(index)")
            let randomSecond = Double(arc4random() % 10 + 1)
            let i = index
            DispatchQueue.main.asyncAfter(deadline: .now() + randomSecond) {
                print("收到数据 \(i)")
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { print("=== end ===\n") }
    }
    
    @objc func semaphore() {
        print("\n=== begin ===")
        
        let semaphore = DispatchSemaphore(value: 0)
        var count = 0
        for index in (1...10) {
            
            print("已经发送 \(index)")
            let randomSecond = Double(arc4random() % 10 + 1)
            let i = index
            
            DispatchQueue.global().asyncAfter(deadline: .now() + randomSecond) {
                print("收到数据 \(i)")
                count += 1
                if count == 10 {
                    
                }
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        print("=== end ===\n")
    }
    
    @objc func success() {
        print("\n=== begin ===")
        
        let semaphore = DispatchSemaphore(value: 1)

        for index in (1...10) {
            semaphore.wait()
            print("已经发送 \(index)")
            let randomSecond = Double(arc4random() % 10 + 1)
            let i = index
            
            DispatchQueue.global().asyncAfter(deadline: .now() + randomSecond) {
                print("收到数据 \(i)")
                semaphore.signal()
            }
        }
        
        print("=== end ===\n")
    }
    
    func simulate(closure:@escaping () -> Void) {
        let randomSecond = Double(arc4random() % 10 + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomSecond, execute: closure)
    }
    
    func simulate(index: Int) {
        print("已经发送 \(index)")
        
        let randomSecond = Double(arc4random() % 10 + 1)
        let i = index
        DispatchQueue.main.asyncAfter(deadline: .now() + randomSecond) {
            print("收到数据 \(i)")
        }
    }
}
