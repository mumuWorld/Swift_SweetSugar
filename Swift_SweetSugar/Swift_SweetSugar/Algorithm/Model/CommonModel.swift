//
//  CommonModel.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/9/16.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

/// 链表
class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
    
    
    static func createLinkedList(from array: [Int]) -> ListNode? {
        guard !array.isEmpty else { return nil }

        let dummy = ListNode(0)
        var current = dummy

        for value in array {
            current.next = ListNode(value)
            current = current.next!
        }

        return dummy.next
    }
}

/// 双向链表
class TwoWayListNode {
    public var val: Int
    public var next: TwoWayListNode?
    public var pre: TwoWayListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
        self.pre = nil
    }
}

/// 二叉树
class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}
