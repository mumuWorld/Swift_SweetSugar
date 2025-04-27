//
//  MMListSubject.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/3/31.
//  Copyright © 2025 Mumu. All rights reserved.
//

import Foundation

class MMListSubject {
    /// 82 删除重复元素
    func deleteDuplicates(_ head: ListNode?) -> ListNode? {
        let dummy = ListNode(0)
        dummy.next = head
        var prev: ListNode? = dummy
        var cur = head

        while cur != nil {
            // 检测重复元素
            if cur?.next != nil && cur?.val == cur?.next?.val {
                let val = cur?.val
                // 跳过所有等于 `val` 的节点
                while cur != nil && cur?.val == val {
                    cur = cur?.next
                }
                prev?.next = cur  // 让 `prev` 直接指向不重复的节点
            } else {
                prev = cur
                cur = cur?.next
            }
        }
        return dummy.next
    }
    
    /// 重复的保留一个，
    func deleteDuplicatesV1(_ head: ListNode?) -> ListNode? {
        let dummy = ListNode(0)
        dummy.next = head
        var cur = head
        while cur != nil, cur?.next != nil {
            if cur?.next?.val == cur?.val {
                cur?.next = cur?.next?.next
            } else {
                cur = cur?.next
            }
        }
        return dummy.next
    }
    
    /// 86 分割链表，
    func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        var sList = ListNode()
        var bList = ListNode()
        let preSList = sList
        let preBList = bList
        var cur = head
        while cur != nil {
            let val = cur?.val ?? 0
            let tmp = ListNode(val)
            if val < x {
                sList.next = tmp
                sList = tmp
            } else {
                bList.next = tmp
                bList = tmp
            }
            cur = cur?.next
        }
        sList.next = preBList.next
        return preSList.next
    }
    
    /// 90 子集 2，
    func subsetsWithDup(_ nums: [Int]) -> [[Int]] {
        var result = [[Int]]()
        var path = [Int]()
        let nums = nums.sorted()  // 排序是关键！

        func backtrack(_ start: Int) {
            result.append(path)  // 收集当前子集

            for i in start..<nums.count {
                // 跳过“同层级”的重复元素
                if i > start && nums[i] == nums[i - 1] {
                    continue
                }

                path.append(nums[i])        // 做选择
                backtrack(i + 1)            // 递归
                path.removeLast()           // 回溯
            }
        }

        backtrack(0)
        return result
    }
    
    //  92. 反转链表 II
    func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int) -> ListNode? {
        
        if head == nil || left == right { return head }
        
        let dummy = ListNode(0)
        dummy.next = head
        var pre: ListNode? = dummy
        
        // 1. 移动 pre 到 left 的前一个节点
        for _ in 1..<left {
            pre = pre?.next
        }
        
        // 2. reverse 部分链表
        let start = pre?.next              // 将被反转的第一个节点
        var then = start?.next            // 正在被反转的节点
        
        for _ in 0..<(right - left) {
            start?.next = then?.next
            then?.next = pre?.next
            pre?.next = then
            then = start?.next
        }
        
        return dummy.next
    }
}
