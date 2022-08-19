//
//  MetalDrawViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2022/8/9.
//  Copyright © 2022 yaoxp. All rights reserved.
//

import UIKit
import MetalKit

class MetalDrawViewController: UIViewController {

    var renderer: Renderer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.clearColor = MTLClearColorMake(0, 1, 0, 1)
        mtkView.enableSetNeedsDisplay = true
        view = mtkView
        
        renderer = Renderer(mtkView: mtkView)
        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = renderer
    }


}
