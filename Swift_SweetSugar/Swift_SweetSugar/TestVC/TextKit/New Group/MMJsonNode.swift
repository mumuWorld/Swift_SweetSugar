//
//  MMJsonNode.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/2/9.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation

struct MMJsonNode {
    enum MMJsonNodeType {
        case obj
        case arr
        case flo
        case str
    }
    
    var type: MMJsonNodeType = .obj
    
    var child: [MMJsonNode]?
    
    var originalChild: [String: Any]?
    
    var key: String?
    
    var value: Any?
    /// 层级: 0 为root
    var level: Int = 0
}
