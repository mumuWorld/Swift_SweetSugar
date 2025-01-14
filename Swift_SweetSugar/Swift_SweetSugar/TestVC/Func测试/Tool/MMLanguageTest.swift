//
//  MMLanguageTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/5/8.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

public protocol MMTestPrintProtocol {
    func testPrint() -> Void
}

/// 语法练习
class MMLanguageTest {
    
    var name: String = "" {
        didSet {
            print("test->name_super: \(name)")
        }
    }
    
    var calName: String {
        get {
            return "calName1特斯特"
        }
        set {
            print("test->calName_super:\(newValue)")
        }
    }
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

extension MMLanguageTest: MMTestPrintProtocol {
    open func testPrint() {
        print("test->MMLanguageTest")
    }
}


class MMLanguageChildTest: MMLanguageTest {
    
    override var name: String {
        didSet {
            print("test->name_child: \(name)")
        }
    }
    
    override var calName: String {
        get {
            return "calName2特斯特"
        }
        set {
            // 必须手动调用super
            super.calName = "测试"
            print("test->calName_child:\(newValue)")
        }
    }
    override init() {
        
    }
    
    override func test() {
        print("test->self: \(self)")
//        print("test->super: \(super)")
        print("test->self: \(self)")
        print("test->self: \(self)")
    }
    
}


struct MMSortItem {
    var couponPrice: Int?
    var expiredTime: Int?
}

protocol Greetable {
    func greet()
}

class Parent {
    // 在类主体中实现协议方法
    func greet() {
        print("Hello from Parent")
    }
}

// 通过扩展来遵循协议
extension Parent: Greetable { }

class Child: Parent {
    override func greet() {
        print("Hello from Child")
    }
}

func teset() {
    // 使用示例
    let parent = Parent()
    parent.greet()  // 输出: Hello from Parent

    let child = Child()
    child.greet()  // 输出: Hello from Child
    // 输出: Hello from Child
}
