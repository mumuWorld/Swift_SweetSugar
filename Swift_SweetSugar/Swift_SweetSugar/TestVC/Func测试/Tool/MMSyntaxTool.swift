//
//  MMSyntaxTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/7/14.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

protocol SayYES {
    func sayYes()
}

extension SayYES {
    func sayYes() {
        print("SayYES: yes")
    }
}

protocol SayNO {
    func sayYes()
}

extension SayNO {
    func sayYes() {
        print("NO: yes")
    }
}

struct MMStruct {
    var name: String = "test"
}

class MMSyntaxTool {
    
    var _student: MMStruct?
    var student_2:  MMStruct? {
        get {
            return _student
        }
        set {
            _student = newValue
            print("test_setter")
        }
    }
    
    func start() {
        print("test->-----------:1 setter start")
        _student = MMStruct()
        // 会调用 test_setter
        student_2?.name = "hello"
        print("test->-----------:1 setter end")

        // 会调用 test2_didSet
        student = MMStruct()
        print("test->-----------:2 didSet start")
        // 会调用 test2_didSet
        student?.name = "hello2"
        print("test->-----------:3 didSet end")
    }
    
    var student: MMStruct? {
        didSet {
            print("test2_didSet")
        }
    }
}

extension MMSyntaxTool: SayYES, SayNO {
    // 只会打印 test
    func sayYes() {
        mm_printLog("test")
    }
}
