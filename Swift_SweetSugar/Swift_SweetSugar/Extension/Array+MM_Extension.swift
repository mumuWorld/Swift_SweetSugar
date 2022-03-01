//
//  Array+MM_Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/2/25.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation

public extension Array {
    
    /// 防止越界取值
    subscript(hold index: Int) -> Element? {
        guard containsIndex(index) else {
            return nil
        }
        return self[index]
    }
    
    /// 是否包含这个index
    func containsIndex(_ index: Int) -> Bool {
        guard (startIndex..<endIndex).contains(index) else {
            return false
        }
        return true
    }
}
