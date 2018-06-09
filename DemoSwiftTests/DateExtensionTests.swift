//
//  DateExtensionTests.swift
//  DemoSwiftTests
//
//  Created by yaoxinpan on 2018/6/8.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import XCTest
@testable import DemoSwift

class DateExtensionTeststTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeZone() {
        
        let dateStr = "2018-06-08 16:43:55"
        let dateFormatter = "yyyy-MM-dd HH:mm:ss"
        
        if let date = Date.date(dateStr, formatter: dateFormatter) {
            
            XCTAssertEqual(date.toString(dateFormatter), dateStr)
            
            XCTAssertEqual(date.hour, 16)
            
        }
        
    }
    
    /*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
