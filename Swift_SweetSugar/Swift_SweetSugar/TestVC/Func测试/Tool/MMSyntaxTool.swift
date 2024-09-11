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
    
    var student: MMStruct? {
        didSet {
            print("test2_didSet")
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

    
    var person: MMClass? {
        didSet {
            print("test->person didSet")
        }
    }
    
    var _person: MMClass?
    var person_2:  MMClass? {
        get {
            return _person
        }
        set {
            _person = newValue
            print("test_setter_person_2")
        }
    }
    
    func start2() {
        // 调用 test->person didSet
        person = MMClass()
        print("test->-----------:1 setter start")
        // 不调用
        person?.name = "hello"
        print("test->-----------:1 setter end")
        
        print("test->-----------:2 didSet start")
        _person = MMClass()
        // 不调用
        person_2?.name = "hello2"
        print("test->-----------:2 didSet end")
    }
    
    func testSwift() {
        print("test->----------")

       let model = MMLanguageChildTest()
        model.name = "name1"
        print("test->----------")
        model.calName = "name2"
        
        print("test->model.call:\(model.calName)")
    }
}

extension MMSyntaxTool: SayYES, SayNO {
    // 只会打印 test
    func sayYes() {
        mm_printLog("test")
    }
}

class MMClass {
    var name: String?
}
