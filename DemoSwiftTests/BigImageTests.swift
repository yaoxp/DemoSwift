//
//  BigImageTests.swift
//  DemoSwiftTests
//
//  Created by yaoxinpan on 2018/9/12.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import XCTest
@testable import DemoSwift

class BigImageTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceOrigin() {
        // This is an example of a performance test case.
        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))
        self.measure {
            imageView.image = image
        }
        print(imageView.frame.size)
    }

    func testPerformanceUI() {
        // This is an example of a performance test case.
        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")
        var newImage: UIImage?
        self.measure {
            newImage = image?.resizeUI(UIScreen.main.bounds.size)
        }
        print(newImage!.size)
    }

    func testPerformanceCG() {

        // This is an example of a performance test case.
        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")
        var newImage: UIImage?
        self.measure {
            newImage = image?.resizeCG(UIScreen.main.bounds.size)
        }
        print(newImage!.size)
    }

    func testPerformanceCI() {
        // This is an example of a performance test case.
        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")
        var newImage: UIImage?
        self.measure {
            newImage = image?.resizeCI(UIScreen.main.bounds.size)
        }
        print(newImage!.size)
    }

    func testPerformanceIO() {
        // This is an example of a performance test case.
        let path = Bundle.main.path(forResource: ImageSource.bigImageName, ofType: nil)
        assert(path != nil, "image path is nil: \(ImageSource.bigImageName)")
        let image = UIImage(contentsOfFile: path!)
        assert(image != nil, "image is nil")
        var newImage: UIImage?
        self.measure {
            newImage = image?.resizeIO(UIScreen.main.bounds.size)
        }
        print(newImage!.size)
    }
}
