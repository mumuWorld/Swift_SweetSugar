//
//  Stack.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/11/20.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

struct Stack<E> {
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
    
    mutating func push(element: E) -> Void {
        elements.append(element)
    }
    
    func peek() -> E? {
        return elements.last
    }
    
    mutating func pop() -> E? {
        if isEmpty() {
            return nil
        }
        return elements.removeLast()
    }
    
    
}


