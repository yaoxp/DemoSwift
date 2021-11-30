//
//  SFFactory.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/11/30.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit

enum SFFactoryProductType {
    case manTou
    case youTiao
}

class SFFactory {
    static func operationBreakfast(_ type: SFFactoryProductType) -> SFOperationProtocol {
        switch type {
        case .manTou:
            return SFOperationManTou()
        case .youTiao:
            return SFOperationYouTiao()
        }
    }
}
