//
//  Renderer.swift
//  DemoSwift
//
//  Created by yaoxp on 2022/8/9.
//  Copyright © 2022 yaoxp. All rights reserved.
//

import Foundation
import MetalKit
import simd

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice?
    var commandQueue: MTLCommandQueue!
    
    init(mtkView: MTKView) {
        device = mtkView.device
        commandQueue = device?.makeCommandQueue()
    }
    
    func draw(in view: MTKView) {
        guard let descriptor = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable else { return }
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        commandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
