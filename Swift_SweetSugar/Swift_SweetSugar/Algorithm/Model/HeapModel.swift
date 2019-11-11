//
//  HeapModel.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/10/10.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

struct Heap<Element> {
    ///存放元素的数组
    var elements: [Element]
    //比较两个元素大小的方法
    let priorityFunction: (Element, Element) -> Bool
    
    init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) { // 1 // 2
        self.elements = elements
        self.priorityFunction = priorityFunction // 3
        buildHeap() // 4
    }
    
    mutating func buildHeap() {
        for index in (0 ..< count / 2).reversed() { // 5
            siftDown(index) // 6
        }
    }
    
    var isEmpty : Bool {
        return elements.isEmpty
    }
    
    var count : Int {
        return elements.count
    }
    
    func peek() -> Element? {
        return elements.first
    }
    func isRoot(_ index: Int) -> Bool {
        return (index == 0)
    }
    ///当前节点的左孩子
    func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }
    ///当前节点的右孩子
    func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }
    ///当前节点的父节点
    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

      //插入
    mutating func equeue(_ element: Element) {
        elements.append(element)
        siftUP(elementAtIndex: elements.count - 1)
    }
    
   //删除
    mutating func dequeue() -> Element? {
        //判空
        guard !isEmpty else { return nil }
        
        //将第一个节点和最后一个节点交换位置
        swapElement(at: 0, with: count - 1)
        //删除原本的第一个，现在的最后一个
        elements.removeLast()
        
        guard !isEmpty else { return nil }
        //向下判断，新的节点是不是优先级最高的节点
        return nil
    }
}

private extension Heap {
    func isHigherPriority(firstIndex: Int, secondIndex: Int) -> Bool{
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(firstIndex: childIndex, secondIndex: parentIndex)
            else { return parentIndex }
        return childIndex
    }
    
    func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(of: highestPriorityIndex(of: parent, and: leftChildIndex(of: parent)), and: rightChildIndex(of: parent))
    }
    
    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex
            else { return }
        elements.swapAt(firstIndex, secondIndex)
    }
    
    mutating func siftDown(_ elementIndex: Int) {
        //从当前节点及子节点中找出优先级最高的节点
        let highestIndex = highestPriorityIndex(for: elementIndex)
        //如果当前节点就是优先级最高的节点，直接放回
        if highestIndex == elementIndex { return }
        //如果不是优先级最高的节点，和优先级最高的节点对换位置
        swapElement(at: elementIndex, with: highestIndex)
        //从新的节点开始递归的向下判断优先级
        siftDown(highestIndex)
    }
    
    mutating func siftUP(elementAtIndex: Int)  {
        //获得父节点的索引
        let parentIndex = self.parentIndex(of: elementAtIndex)
        //如果当前节点不是根节点，比较当前节点和父节点的优先级
        guard !isRoot(elementAtIndex), isHigherPriority(firstIndex: elementAtIndex, secondIndex: parentIndex) else {
            return
        }
        //如果当前节点的优先级高于父节点，兑换位置
        swapElement(at: elementAtIndex, with: parentIndex)
        
        //递归的从新的父节点开始向上比较
        siftUP(elementAtIndex: parentIndex)
    }
}

