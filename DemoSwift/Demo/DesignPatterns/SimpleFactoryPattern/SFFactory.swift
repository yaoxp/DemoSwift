//
//  SFFactory.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/11/30.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit

enum SFShoesType {
    case adiWang
    case nike
}

class SFFactory {
    static func makeShoes(_ type: SFShoesType) -> SFShoesProtocol {
        switch type {
        case .adiWang:
            return SFAdiWang()
        case .nike:
            return SFNike()
        }
    }
}
