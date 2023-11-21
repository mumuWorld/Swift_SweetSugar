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


extension Sequence where Element: Hashable {
    // 测试，
    var frequencies: [Element:Int] {
        let frequencyPairs = self.map { ($0, 1) }
        // 会将元祖数组中的相同key的value进行相加
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}


extension Optional {
    func map<U>(transform: (Wrapped) -> U) -> U? {
        guard let value = self else { return nil }
        return transform(value)
    }
}

extension Array {
    
    /// 内部判断数组是否为空
    /// - Parameter nextPartialResult: 累加回调
    /// - Returns: 返回
    func reduce(_ nextPartialResult: (Element, Element) -> Element) -> Element? {
        // 如果数组为空，first 将是 nil
        guard let fst = first else { return nil }
        return dropFirst().reduce(fst, nextPartialResult)
    }
    
    /// 内部判断数组是否为空
    /// - Parameter nextPartialResult: 累加回调
    /// - Returns: 返回
    func reduce_alt(_ nextPartialResult: (Element, Element) -> Element)
    -> Element? {
        return first.map {
            dropFirst().reduce($0, nextPartialResult)
        }
    }
}


infix operator ???: NilCoalescingPrecedence

public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: 
        return String(describing: value)
    case nil:
        return defaultValue()
    }
}

//MARK: - 优化强制解包

infix operator !!
func !! <T>(wrapped: T?, failureText: @autoclosure () -> String) -> T { 
    if let x = wrapped { return x }
    mm_printLog("test->强制解包失败!")
    fatalError(failureText())
}
