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
    
    func testArray() {
        HardArray().start()
    }

    override func setUp() {
        
    }
    
    func testString() {
        let arr = StringSolution().permute("abcd")
        print("test->arr:\(arr)")
    }
    
    func testSwift() {
        print("test->----------")

       let model = MMLanguageChildTest()
        model.name = "name1"
        print("test->----------")
        model.calName = "name2"
        
        print("test->model.call:\(model.calName)")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        GCDTest().test3()
//      let result =  ArrayAlgorithm().longestConsecutive(nums: [7,6,5,3,2,1,8])
//        print("test->reuslt:\(result)")
        
        
        
        // 示例数组
//        let playlist = ["Song 1", "Song 2", "Song 3", "Song 4", "Song 5"]
//        ArrayAlgorithm().playRandomly(playlist: playlist)
//        
        let result = ArrayAlgorithm().generateMatrix(3)
//        let arr = ArrayAlgorithm().printN(num: 4)
        for row in result {
            print(row)
        }
//        print("test->arr:\(arr_1)")
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
        print("test->start")
        GCDTest().AllTestEntry()
        print("test->end")

    }
    
    func gcdDo() {
        
    }
    
    func testSyntax() {
        print("test->strat")
//        MMSyntaxTool().sayYes()
        MMSyntaxTool().start()
        print("test->end---------------")
//        BaseSynatx().test()
//        BaseSynatx().blockTest()
    }
    
    func testSort() {
        var arr = [77, 27, 44, 73, 30, 33,  20]
        var arr_2 = [3, 5, 9, 4, 2, 7,  6]
        print("test->arr:\(arr_2)")
//        QuickSort<Int>().quickSort(&arr_2, low: 0, high: arr.count - 1)
        let arr_result = MergeSort<Int>().mergeSort(arr_2)
        print("test->arr:\(arr_result)")

    }
}
