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

    /// https://leetcode.cn/problems/unique-paths/description/
    /// 62. 不同路径
    func uniquePaths(_ m: Int, _ n: Int) -> Int {
        var dp = Array(repeating: Array(repeating: 0, count: n), count: m)
        for i in 0..<m {
            for j in 0..<n {
                if i == 0 || j == 0 {
                    dp[i][j] = 1
                } else {
                    dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
                }
            }
        }
        return dp[m - 1][n - 1]
    }
    
    func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
        let m = obstacleGrid.count
        let n = obstacleGrid[0].count
        var dp = Array(repeating: Array(repeating: 0, count: n), count: m)
        for i in 0..<m {
            for j in 0..<n {
                if obstacleGrid[i][j] == 1 {
                    dp[i][j] = 0
                } else if i == 0 && j == 0 {
                    dp[i][j] = 1
                } else if i == 0 {
                    dp[i][j] = dp[i][j - 1]
                } else if j == 0 {
                    dp[i][j] = dp[i - 1][j]
                } else {
                    dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
                }
            }
        }
        return dp[m - 1][n - 1]
            
    }
    
    /// 64, 最小路径和
    func minPathSum(_ grid: [[Int]]) -> Int {
        let m = grid.count
        let n = grid[0].count
        var dp = Array(repeating: Array(repeating: 0, count: n), count: m)
        for i in 0..<m {
            for j in 0..<n {
                let v = grid[i][j]
                if i == 0, j == 0 {
                    dp[i][j] = v
                } else if i == 0 {
                    dp[i][j] = v + dp[i][j - 1]
                } else if j == 0 {
                    dp[i][j] = v + dp[i - 1][j]
                } else {
                    dp[i][j] = min(dp[i][j - 1], dp[i - 1][j]) + v
                }
            }
        }
        return dp[m - 1][n - 1]
    }
    
    /// 66 加一
    func plusOne(_ digits: [Int]) -> [Int] {
        var result = digits
        var needPlus = true
        for (i, v) in digits.enumerated().reversed() {
            var r = v
            if needPlus {
                r = v + 1
            }
            if r > 9 {
                result[i] = r % 10
                needPlus = true
            } else {
                result[i] = r
                needPlus = false
            }
        }
        if needPlus {
            result.insert(1, at: 0)
        }
        return result
    }
    
    /// 71 简化路径
    func simplifyPath(_ path: String) -> String {
        let arr = path.split(separator: "/")
        
        var stack = [String]()
        for (i, cur) in arr.enumerated() {
            if cur == "." {
                
            } else if cur == ".." {
                if stack.isEmpty == false {
                    stack.removeLast()
                }
            } else if cur.isEmpty {
                
            } else {
                stack.append(String(cur))
            }
        }
        let result = stack.joined(separator: "/")
        return "/" + result
    }
    
    /// 72 编辑距离: 插入、删除、替换、
    func minDistance(_ word1: String, _ word2: String) -> Int {
        let m = word1.count
        let n = word2.count
        
        // 如果其中一个为空串，则编辑距离为另一个字符串的长度
        if m * n == 0 {
            return m + n
        }
        
        let arr1 = Array(word1)
        let arr2 = Array(word2)
        
        var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        for i in 0...m {
            dp[i][0] = i
        }
        for j in 0...n {
            dp[0][j] = j
        }
        for i in 1...m {
            for j in 1...n {
                // 或者直接使用word1[i - 1] == word2[j - 1]
                if arr1[i - 1] == arr2[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1]
                } else {
                    dp[i][j] = min(min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]) + 1
                }
            }
        }
        return dp[m][n]
    }
    
    // 75 颜色分类
    func sortColors(_ nums: inout [Int]) {
        // 0 的 index
        var fIndex = 0
        // 2 的 index
        var tIndex = nums.count - 1
        var cur = 0
        
        while cur <= tIndex {
            if nums[cur] == 0 {
                nums.swapAt(cur, fIndex)
                fIndex += 1
                cur += 1
            } else if nums[cur] == 2 {
                nums.swapAt(cur, tIndex)
                tIndex -= 1
                // 这里 `i` 不增加，因为交换后的 `nums[i]` 仍需要检查
            } else if nums[cur] == 1 {
                cur += 1
            }
        }
    }
    
    // 77 组合
    func combine(_ n: Int, _ k: Int) -> [[Int]] {
        var result: [[Int]] = []
        var path: [Int] = []
        
        func backtrack(_ start: Int) {
            if path.count == k {
                result.append(path)
                return
            }
            
            if start > n { return }
            
            for i in start...n {
                path.append(i)
                backtrack(i + 1)
                path.removeLast()
            }
        }
        backtrack(1)
        return result
    }
    
    // 80 删除排序数组中的重复项, 原地删除【允许最多出现两次】
    /* 给你一个有序数组 nums ，请你 原地 删除重复出现的元素，使得出现次数超过两次的元素只出现两次 ，返回删除后数组的新长度。
     不要使用额外的数组空间，你必须在 原地 修改输入数组 并在使用 O(1) 额外空间的条件下完成。*/
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        if nums.count <= 2 {
            return nums.count
        }
        var slow = 2
        for fast in 2..<nums.count {
            if nums[slow - 2] != nums[fast] {
                nums[slow] = nums[fast]
                slow += 1
            }
        }
        return slow
    }
    
    // 91. 解码方程
    func numDecodings(_ s: String) -> Int {
        if s.isEmpty || s.first! == "0" {
            return 0
        }
        if s.count == 1 {
            return 1
        }
        let chars = Array(s)
        let n = chars.count
        var dp = [Int](repeating: 0, count: n + 1)

        dp[0] = 1  // 空字符串
        dp[1] = 1  // 第一位已经不是 0，肯定能解

        for i in 2...n {
            let oneDigit = Int(String(chars[i - 1]))!
            let twoDigits = Int(String(chars[i - 2...i - 1]))!
            
            if oneDigit != 0 {
                dp[i] += dp[i - 1]
            }

            if twoDigits >= 10 && twoDigits <= 26 {
                dp[i] += dp[i - 2]
            }
        }

        return dp[n]
    }
}
