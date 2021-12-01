//
//  FFactory.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/11/30.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import Foundation

enum AFFactoryType {
    case adiWang
    case nike
}

protocol AFFactoryProtocol {
    func makeShoes() -> AFShoesProtocol
}

class AFFactory {
    static func factory(with type: AFFactoryType) -> AFFactoryProtocol {
        switch type {
        case .adiWang:
            return AFFactoryAdiWang()
        case .nike:
            return AFFactoryNike()
        }
    }
}
