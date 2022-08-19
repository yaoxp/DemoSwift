//
//  MetalAdder.swift
//  DemoSwift
//
//  Created by yaoxp on 2022/8/8.
//  Copyright © 2022 yaoxp. All rights reserved.
//

import Foundation
import Metal

fileprivate let arrayLength = 1 << 16
fileprivate let bufferSize = arrayLength * MemoryLayout<Float>.stride

class MetalAdder {
    var device: MTLDevice!
    var addFunctionPSO: MTLComputePipelineState!
    var commandQueue: MTLCommandQueue!
    var bufferA: MTLBuffer!
    var bufferB: MTLBuffer!
    var bufferResult: MTLBuffer!
    
    init?(with device: MTLDevice) {
        self.device = device
        guard let defaultLibrary = self.device.makeDefaultLibrary() else {
            logger.error("Failed to find the default library.")
            return nil
        }
        guard let addFunction = defaultLibrary.makeFunction(name: "add_arrays") else {
            logger.error("Failed to find the add function.")
            return nil
        }
        do {
            addFunctionPSO = try device.makeComputePipelineState(function: addFunction)
        } catch {
            logger.error("Failed to find the add function.")
            return nil
        }
        
        commandQueue = device.makeCommandQueue()
    }
    
    func testGPUCompute() {
        createBufferData()
        sendComputeCommand()
    }
    
    private func createBufferData() {
        bufferA = device.makeBuffer(length: bufferSize, options: .storageModeShared)
        bufferB = device.makeBuffer(length: bufferSize, options: .storageModeShared)
        bufferResult = device.makeBuffer(length: bufferSize, options: .storageModeShared)
        let pointA = bufferA.contents().bindMemory(to: Float.self, capacity: arrayLength)
        let pointB = bufferB.contents().bindMemory(to: Float.self, capacity: arrayLength)
        for i in 0..<arrayLength {
            pointA[i] = Float.random(in: -1000000.0...1000000.0)
            pointB[i] = Float.random(in: -1000000.0...1000000.0)
        }
    }
    
    private func sendComputeCommand() {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            logger.critical("Failed to create command buffer.")
            return
        }
        guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            logger.critical("Failed to create command encoder.")
            return
        }
        
        computeEncoder.setComputePipelineState(addFunctionPSO)
        computeEncoder.setBuffer(bufferA, offset: 0, index: 0)
        computeEncoder.setBuffer(bufferB, offset: 0, index: 1)
        computeEncoder.setBuffer(bufferResult, offset: 0, index: 2)
        
        let gridSize = MTLSizeMake(arrayLength, 1, 1)
        var threadGroupSize = addFunctionPSO.maxTotalThreadsPerThreadgroup
        if threadGroupSize > arrayLength {
            threadGroupSize = arrayLength
        }
        let threadSize = MTLSizeMake(threadGroupSize, 1, 1)
        computeEncoder.dispatchThreadgroups(gridSize, threadsPerThreadgroup: threadSize)
//        computeEncoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadSize)
        
        computeEncoder.endEncoding()
        
        logger.debug("gpu compute start.")
        let date = Date()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        // ns
        let timeInterval = Int(Date().timeIntervalSince(date) * 1000 * 1000)
        logger.debug("gpu compute time interval: \(timeInterval) ns")
        
        verifyResult()
    }

    private func verifyResult() {
        let pointA = bufferA.contents().bindMemory(to: Float.self, capacity: arrayLength)
        let pointB = bufferB.contents().bindMemory(to: Float.self, capacity: arrayLength)
        let pointResult = bufferResult.contents().bindMemory(to: Float.self, capacity: arrayLength)
        var success = true
        for index in 0..<arrayLength {
            if pointResult[index] != pointA[index] + pointB[index] {
                success = false
                break
            }
        }
        if !success {
            logger.error("[Metal] compute error.")
        }
    }
    
    
    func testCPUCompute() {
        var array1: [Float] = Array(repeating: 0, count: arrayLength);
        var array2: [Float] = Array(repeating: 0, count: arrayLength);
        var array3: [Float] = Array(repeating: 0, count: arrayLength);
        for index in 0..<arrayLength {
            array1[index] = Float.random(in: -1000000.0...1000000.0)
            array2[index] = Float.random(in: -1000000.0...1000000.0)
        }
        logger.debug("cpu compute start.")
        let date = Date()
        for index in 0..<arrayLength {
            array3[index] = array1[index] + array2[index]
        }
        // ns
        let timeInterval = Int(Date().timeIntervalSince(date) * 1000 * 1000)
        logger.debug("cpu compute time interval: \(timeInterval) ns")
    }
}
