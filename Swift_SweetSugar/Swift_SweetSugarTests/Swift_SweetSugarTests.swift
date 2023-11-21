//
//  Swift_SweetSugarTests.swift
//  Swift_SweetSugarTests
//
//  Created by mumu on 2019/4/1.
//  Copyright © 2019年 Mumu. All rights reserved.
//

import XCTest
@testable import Swift_SweetSugar

class Swift_SweetSugarTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
//        GCDTest().test3()
      let result =  ArrayAlgorithm().longestConsecutive(nums: [7,6,5,3,2,1,8])
        print("test->reuslt:\(result)")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testGCD() {
//        GCDTest().test1()
        GCDTest().AllTestEntry()
    }
    
    func gcdDo() {
        
    }
    
    func testSyntax() {
        print("test->strat")
        MMSyntaxTool().sayYes()
        print("test->end---------------")
//        BaseSynatx().test()
        BaseSynatx().blockTest()
    }
}
