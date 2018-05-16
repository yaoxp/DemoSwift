//
//  ThreeTouchPreviewActionDelegate.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/5/16.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import Foundation

protocol ThreeTouchPreviewActionDelegate: class {

    func previewAction(setTop index: IndexPath?)
    func previewAction(delete index: IndexPath?)
}
