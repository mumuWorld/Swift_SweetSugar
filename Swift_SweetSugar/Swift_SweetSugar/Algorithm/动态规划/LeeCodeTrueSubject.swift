//
//  LeeCodeTrueSubject.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/10/21.x
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class LeetCodeTureSubject {
    var cacheDic: [Int: Int] = Dictionary()
    
    /// 打家劫舍 【动态规划】
    /// https://leetcode-cn.com/problems/house-robber/
    func rob(_ nums: [Int]) -> Int {
        //每个房屋有两种选择  偷 或 不偷
        if nums.count <= 1 {
            return nums.first ?? 0
        }
        let max = getMaxSum(index: nums.count - 1, nums: nums);
        return max
    }
//    复杂度 (2^n)
    func getMaxSum(index: Int, nums: [Int]) -> Int {
        if let max = cacheDic[index] {
            return max
        }
        mm_printsLog(index)
        if index == 0 {
            return nums[index];
        } else if index == 1 {
            return max(nums[index], nums[0])
        }
        let sum = nums[index] + getMaxSum(index: index - 2, nums: nums);
        let sum2 = getMaxSum(index: index - 1, nums: nums);
        let maxSum: Int = max(sum, sum2)
        cacheDic[index] = maxSum
        return maxSum
    }
 
    /// 最简写法
    /// - Parameter nums: 数组
    func rob2(_ nums: [Int]) -> Int {
        var prev = 0
        var curr = 0
        for i in nums {
            let tmp = curr
            curr = max(prev + i, curr)
            prev = tmp
        }
        return curr
    }
}
