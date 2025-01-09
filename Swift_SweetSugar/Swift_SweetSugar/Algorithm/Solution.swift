//
//  Solution.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/7/3.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class Solution {
    /// 两数之和     哈希表。
    /// https://leetcode-cn.com/problems/two-sum/
    /// - Parameters:
    ///   - target: 目标值
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        // for  i in 0..<nums.count {
        //      let num1 = nums[i];
        //      for  j in (i+1)..<nums.count {
        //          let num2 = nums[j];
        //          if (num1 + num2) == target {
        //              return [i,j]
        //          }
        //      }
        //  }
        // return []
        var map = Dictionary<Int64, Int>()
        for i in 0..<nums.count {
            let comTar = target - nums[i]
            if map.keys.contains(Int64(comTar)) {
                return [i,map[Int64(comTar)]!]
            }
            map[Int64(nums[i])] = i
        }
        return []
    }
    
    /// 三数之和
    /// https://leetcode-cn.com/problems/3sum/
    func threeSum(_ nums: [Int]) -> [[Int]] {
        if nums.count < 3 {  //原来是少了一个空数组的判断
            return []
        }
        print(nums)
        var mutiNums = nums //先进行排序
        mutiNums.sort { (num1, num2) -> Bool in
            return num1 < num2
        }
        var result:[[Int]] = Array()
        
        if mutiNums[0] > 0 || mutiNums[nums.count - 1] < 0 {  //容错判断
            return result
        }
        var tmpIndex = 0
//        for i in 0..<mutiNums.count - 2 {  //也可以改用for in 循环。
        repeat {
            let i = tmpIndex
            
            if mutiNums[i] > 0 {
                break
            }
            if tmpIndex > i {
                continue
            }
            tmpIndex = i
            var first = i + 1
            var last = mutiNums.count - 1
            repeat {
                if first >= last || mutiNums[i] * mutiNums[last] > 0 { //两个相同或者三个数都为正
                    break;
                }
                let sum = mutiNums[i] + mutiNums[first] + mutiNums[last]
                if sum == 0 {
                    result.append([mutiNums[i],mutiNums[first],mutiNums[last]])
                }
                if sum <= 0 {
                    let tmpFirst = first
                    repeat {
                        first += 1
                    } while(first < last && mutiNums[first] == mutiNums[tmpFirst])
                } else {
                    let tmpLast = last
                    repeat {
                        last -= 1
                    } while (first < last && mutiNums[last] == mutiNums[tmpLast])
                }
            } while (first < last)
            
            repeat {
                tmpIndex += 1
            } while (tmpIndex < mutiNums.count-2  && mutiNums[i] == mutiNums[tmpIndex])
        } while (tmpIndex < mutiNums.count-2)
        return result
    }
    
    /// 无重复最长子串
    /// https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/
    func lengthOfLongestSubstring(_ s: String) -> Int {
        return 0
    }
    
    
    /// 逆波兰表达式
    /// https://leetcode-cn.com/problems/evaluate-reverse-polish-notation/
    /// - Parameter tokens: source
    /// - Returns: reslut
    func evalRPN(_ tokens: [String]) -> Int {
        var stackArr:[Int] = Array()
        
        stackArr.append(0)
        for item in tokens {
            if let itemValue = Int(item) {
                stackArr.append(itemValue)
            } else {
//                 = stackArr.last
                let second = stackArr.remove(at: stackArr.count - 1)
                let first = stackArr.remove(at: stackArr.count - 1)
                var result = 0
                if item == "+" {
                    result = first + second
                } else if item == "-" {
                    result = first - second
                    
                } else if item == "*" {
                    result = first * second
                    
                } else if item == "/" {
                    if first == 0 || second == 0 {
                        result = 0
                    } else {
                        result = first / second 
                    }
                }
                stackArr.append(result)
            }
        }
        return stackArr.last!
    }
    

    /**  合并两个有序链表
     * https://leetcode-cn.com/problems/merge-two-sorted-lists/
     * Definition for singly-linked list.
     * public class ListNode {
     *     public var val: Int
     *     public var next: ListNode?
     *     public init(_ val: Int) {
     *         self.val = val
     *         self.next = nil
     *     }
     * }
     */
        func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
            
            if l1 == nil {
                return l2
            }  else if l2 == nil {
                return l1
            }
//            guard let l1List = l1 else { return l2 }
//            guard let l2List = l2 else { return l1List }
            
            var k1List: ListNode? = l1
            var k2List: ListNode? = l2

            /// 虚拟头结点  dummy head
            let head: ListNode? = ListNode(0)
            
            var curList = head
            while k1List != nil, k2List != nil {
                if k1List!.val <= k2List!.val {
                    curList?.next = k1List
                    k1List = k1List?.next
                } else {
                    curList?.next = k2List
                    k2List = k2List?.next
                }
                curList = curList?.next
            }
            
            if k1List == nil {
                curList?.next = k2List
            } else {
                curList?.next = k1List
            }
            
            return head?.next
        }
        
        

    
    
    /// 合并k个有序链表
    ///  https://leetcode-cn.com/problems/merge-k-sorted-lists/
    /// - Parameter lists: list
    /// - Returns: node
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
        
        //小顶堆  优先级队列
        //将d所有链表的头结点添加到小顶堆(优先级队列)中
        //不断删除堆顶元素、 并且把对顶元素的next 添加到堆中
        
        //方法2 分治策略
        if  lists.count == 0 {
            return nil
        }
        var tmpList = lists
        
        var step = 1
        while step < tmpList.count {
            let nextStep = step << 1
            for i in stride(from: 0, to: tmpList.count, by: nextStep) {
                if i + step >= tmpList.count {
                    break
                }
                tmpList[i] = mergeTwoLists(tmpList[i], tmpList[i + step])
            }
            step = nextStep
        }
        return tmpList.first!
    }
    
    /*
     https://leetcode.cn/problems/alternating-groups-i/description/?envType=daily-question&envId=2024-11-26
     3206. 交替组 I
     */
    class Solution {
        func numberOfAlternatingGroups(_ colors: [Int]) -> Int {
            var count = 0
            for (i, item) in colors.enumerated() {
                let leftItem = i == 0 ? colors.count - 1 : i - 1
                let rightItem = i == colors.count - 1 ? 0 : i + 1
                let left = colors[leftItem]
                let right = colors[rightItem]
                if item != left && item != right {
                    count += 1
                }
            }
            return count
        }
    }
    /*
     6. Z 字形变换
     https://leetcode.cn/problems/zigzag-conversion/description/
     */
    func convert(_ s: String, _ numRows: Int) -> String {
        if numRows < 2 { // 边界条件
            return s
        }
        var result: [[Character]] = Array(repeating: [], count: numRows)
        var row = 0
        var down = false
        
        for c in s {
            result[row].append(c)
            if row == 0 || row == numRows - 1 {
                down.toggle()
            }
            row += down ? 1 : -1
            print("test->row: \(row), \(down)")
        }
        let str = result.flatMap { $0 }.map({ String($0) }).joined()
        return str
    }
    
    /*
     
     */
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        // find middle number
        let count = nums1.count + nums2.count
        
        return 0
    }
}
