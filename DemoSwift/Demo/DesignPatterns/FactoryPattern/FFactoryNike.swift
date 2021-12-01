//
//  FFactoryYouTiao.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/11/30.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit

class FFactoryNike: FFactoryProtocol {
    static func makeShoes() -> FShoesProtocol {
        return FNike()
    }

}
