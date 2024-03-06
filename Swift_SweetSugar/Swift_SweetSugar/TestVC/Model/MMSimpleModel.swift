//
//  MMSimpleModel.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/8/27.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation

struct MMSimpleModel {
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
}

class MMSimpleChildClass: MMSimpleClass {
    
}
