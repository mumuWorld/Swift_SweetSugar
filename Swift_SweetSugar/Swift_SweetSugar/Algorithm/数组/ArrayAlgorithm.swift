//
//  ArrayAlgorithm.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/10/30.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

class ArrayAlgorithm {
    
    /// 给定一个未排序的整数数组 nums ，找出数字连续的最长序列（不要求序列元素在原数组中连续）的长度。
    /// - Parameter nums:     请你设计并实现时间复杂度为 O(n) 的算法解决此问题。
    func longestConsecutive(nums: [Int]) -> Int {
        var set = Set<Int>()
        var maxLength = 0
        
        // 将数组中的元素加入到集合中
        for num in nums {
            set.insert(num)
        }
        
        // 遍历数组，寻找序列的起点
        for num in nums {
            if !set.contains(num - 1) {
                var currentNum = num
                var currentLength = 1
                print("test->cur: \(currentNum)")
                // 统计序列的长度
                while set.contains(currentNum + 1) {
                    currentNum += 1
                    currentLength += 1
                    print("test->cur2: \(currentNum)")
                }
                
                maxLength = max(maxLength, currentLength)
            }
        }
        return maxLength
    }
    
}
