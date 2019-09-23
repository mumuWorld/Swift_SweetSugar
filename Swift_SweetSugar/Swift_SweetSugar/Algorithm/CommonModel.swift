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
    public init(_ val: Int) {
        self.val = val
        self.next = nil
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
