//
//  MMLanguageTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/5/8.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

/// 语法练习
class MMLanguageTest {
    
    func test() {
        test_str()
    }
    
    func test_str() {
        // 标识字符串字面量，原始字符串字面量中，这些特殊字符都可以直接使用，不需要转义。
        let jsonStr = #"{ "sku": 12345, "isAvailable": "true" }"#
        let json = #"{ "sku": 12345, "isAvailable": "true" }"#.data(using: .utf8)!
        let string4 = """

            this is me, ok, this is next \
            line
            """
        mm_printLog("test->\(string4)")
    }
}
