//
//  BaseSynatx.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/9/22.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation


class BaseSynatx {
    
    func test() {
        func foo() throws -> Int { 0 }
        func foo() throws -> Int? { 1 }
        
        let a = (try? foo())
//        let b = (try? foo())!
        let b = (try! foo())!
        
        let result = (a == b)
        
        mm_printLog("test->a:\(a), b:\(b), result: \(result)")
    }
    
    func blockTest() {
        func makeIncrementer(forIncrement amount: Int) -> () -> Int {
            var runningTotal = 0
            func incrementer() -> Int {
                runningTotal += amount
                return runningTotal
            }
            return incrementer
        }
        
        let value = makeIncrementer(forIncrement: 10)
        let result = value()
        let value2 = makeIncrementer(forIncrement: 10)
        let result2 = value2()
        let result3 = value2()
        let result4 = value2()

//        let value3 = makeIncrementer(forIncrement: 10)
//        let result3 = value3()
//        let value4 = makeIncrementer(forIncrement: 10)
//        let result4 = value4()
//        let result5 = value4()
        print("test->value:\(result), \(result2), \(result3), \(result4)")
    }
}


