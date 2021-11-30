//
//  NinePatchImageTest.swift
//  DemoSwiftTests
//
//  Created by yaoxp on 2021/7/26.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import XCTest
@testable import DemoSwift

class NinePatchImageTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformance001() throws {
        let imageName = "android.9.png"
        guard let file = Bundle.main.path(forResource: imageName, ofType: nil),
              let image = UIImage(contentsOfFile: file) else {
            XCTAssert(false)
            return
        }
        self.measure {
            let newImage = NinePatchImageFactory.createStretchableImage2(with: image)
            print(newImage?.size)
        }
    }

    func testPerformance002() throws {
        let imageName = "android.9.png"
        guard let file = Bundle.main.path(forResource: imageName, ofType: nil),
              let image = UIImage(contentsOfFile: file) else {
            XCTAssert(false)
            return
        }
        self.measure {
            let newImage = NinePatchImageFactory.createStretchableImage(with: image)
            print(newImage?.size)
        }
    }

}
