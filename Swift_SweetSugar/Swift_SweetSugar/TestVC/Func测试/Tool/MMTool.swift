//
//  MMTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/3/15.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

class MMTool {
    static func getAllPropertys(clsName: Any?) -> [String] {
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(clsName), count)
        let countInt = Int(count[0])
        for i in 0..<countInt {
            if let temp = buff?[i] {
                let cname = property_getName(temp)
                let proper = String(cString: cname)
                result.append(proper)
            }
        }
        return result
    }

    static func getAllIvarList(clsName: Any?) -> [String] {
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyIvarList(object_getClass(clsName), count)
        let countInt = Int(count[0])
        for i in 0..<countInt {
            if let temp = buff?[i],let cname = ivar_getName(temp) {
                let proper = String(cString: cname)
                result.append(proper)
            }
        }
        return result
    }
}


class MMCommonShare {
    static let shareInstance: MMCommonShare = MMCommonShare()
    
    lazy var blockClass2: MMBlockClass2 = {
        let item = MMBlockClass2()
        return item
    }()
}
