//
//  MMSimpleModel.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/8/27.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation

struct MMSimpleStruct: Equatable {
    var name: String?
//    var target: AnyObject?
//    
//    static func post<P: Codable>(url: String, param: P? = nil) {
//        
//    }
}

struct MMSimpleStruct2: Equatable {
    var name: String?
//    var target: AnyObject?
//
//    static func post<P: Codable>(url: String, param: P? = nil) {
//
//    }
}

//protocol MMSimpleProtocol {
//    static func post<P: Codable>(url: String, param: P? = nil)
//}

class MMSimpleClass {
    static func post<P: Codable>(url: String, param: P? = nil) {
        
    }
    final var name: String?
    
    var otherClass: MMSimpleClass?
    
    // 不能同时修饰
//    final class var clsName: String?
}


class MMSimpleChildClass: MMSimpleClass {
    
}


class MMSimpleOCClass: NSObject {
    var name: String?
}


