//
//  FFactory.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/11/30.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import Foundation

protocol FFactoryProtocol {
    static func makeShoes() -> FShoesProtocol
}
