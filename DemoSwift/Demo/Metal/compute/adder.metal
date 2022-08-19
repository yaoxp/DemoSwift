//
//  adder.metal
//  DemoSwift
//
//  Created by yaoxp on 2022/8/8.
//  Copyright © 2022 yaoxp. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


kernel void add_arrays(device const float* inA,
                       device const float* inB,
                       device float* result,
                       uint index [[thread_position_in_grid]]) {
    result[index] = inA[index] + inB[index];
}
