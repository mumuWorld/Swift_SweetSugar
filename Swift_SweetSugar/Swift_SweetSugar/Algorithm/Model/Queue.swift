//
//  Queue.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/11/20.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

struct Queue<E> {
    private var elements: [E]
    
    init() {
        elements = Array()
    }
    
    func count() -> Int {
        return elements.count
    }
    
    func isEmpty() -> Bool {
        return elements.count == 0
    }
    
    func peek() -> E? {
        return elements.first
    }
    
    /// 入栈
    /// - Parameter element:
    mutating func enqueue(element: E) -> Void {
        elements.append(element)
    }
    
    
    /// 出栈
    mutating func dequeue() -> E? {
        if isEmpty() {
            return nil
        }
        return elements.removeFirst()
    }
}
