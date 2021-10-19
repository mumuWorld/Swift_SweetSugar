//
//  MMFuncTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/27.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import UIKit

class MMFuncTool {
    func past() {
//        UIPasteboard.general.string = "http://hellow world"
        let pasted = UIPasteboard.general
        if #available(iOS 14.0, *) {
            pasted.detectPatterns(for: Set(arrayLiteral: UIPasteboard.DetectionPattern.probableWebSearch, .probableWebURL, .number)) { result in
                switch result {
                case .success(let results):
                    for item in results {
                        if item == .probableWebSearch {
                            mm_printLog("测试1")
                        } else if item == .number {
                            mm_printLog("测试2")
                        } else if item == .probableWebURL {
                            mm_printLog("测试3")
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        } else {
            
        }
        mm_printLog("str->\(pasted.string)")
        mm_printLog("str->\(pasted.strings)")

    }
    
    func makeData(s: String) {
//        s.data(using: .utf8).map {
////            JSONSerialization.jsonObject(with: <#T##Data#>, options: <#T##JSONSerialization.ReadingOptions#>)
//            try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed)
//        }?.map({
//            MMFuncTool()
//        })
    }
    
    func operationQueueTest() {
        let operation = Operation()
        operation.completionBlock = {
            mm_printLog("finished")
        }
        OperationQueue.main.addOperation(operation)
        
        MMFuncTool.add(a: 1, b: 3) { result in
            mm_printLog(result)
        }
    }
    
    static func add(a: Int, b: Int, block: @escaping ((Int) -> Void)) {
        OperationQueue.main.addOperation {
            block(a + b)
        }
    }
}


protocol MMEmptyProtocol {
    func testPrint()
}

extension MMEmptyProtocol {
    func testPrint() {
        mm_printLog(self)
    }
}

extension MMFuncTool: MMEmptyProtocol {}

extension FuncTestVC: MMEmptyProtocol {}


