//
//  MetalViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2022/8/8.
//  Copyright © 2022 yaoxp. All rights reserved.
//

import UIKit
import Metal

class MetalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func onComputeAction(_ sender: Any) {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            logger.error("not support Metal.")
            return
        }
        guard let metalAdder = MetalAdder(with: metalDevice) else { return }
        metalAdder.testCPUCompute()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            metalAdder.testGPUCompute()
        }
    }
    
    @IBAction func onDrawAction(_ sender: Any) {
        let vc = MetalDrawViewController()
        navigationController?.present(vc, animated: true)
    }
    
}
