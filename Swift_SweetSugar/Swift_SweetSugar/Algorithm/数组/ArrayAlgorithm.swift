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
    
    // 随机播放函数
    func playRandomly(playlist: [String]) {
        var _playList = playlist
        // 使用shuffled()打乱数组
        //        let shuffledPlaylist = _playList.shuffled()
        _playList.mm_shuffle()
        
        let shuffledPlaylist = _playList
        // 初始化播放索引
        var currentIndex = 0
        
        // 播放当前索引的元素
        func playCurrent() {
            if currentIndex < shuffledPlaylist.count {
                print("Playing: $shuffledPlaylist[currentIndex])")
                print("test->播放: \(_playList[currentIndex])")
                
                currentIndex += 1
                // 延迟一段时间以模拟播放，然后继续播放下一个
                // 这里使用DispatchQueue.main.asyncAfter来模拟延迟
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    playCurrent() // 注意：这里需要使用self来引用外部的playCurrent闭包
                }
            } else {
                // 播放结束，可以选择重新开始或者停止
                //                print("Playback completed. Restarting...")
                //                playRandomly(playlist: playlist) // 重新开始
            }
        }
        
        // 调用播放当前元素的函数
        playCurrent()
    }
    
    func printN(num: Int) -> [[Int]]? {
        guard num > 0 else { return nil }
        var arr:[[Int]] = Array(repeating: Array(repeating: 0, count: num), count: num)
        
        var rowStart: Int = 0
        
        var rowEnd: Int = num - 1
        
        var colStart: Int = 0
        
        var colEnd: Int = num - 1
        
        var curNum: Int = 1
        
        while rowStart <= rowEnd && colStart <= colEnd {
            
            for i in colStart...colEnd {
                arr[rowStart][i] = curNum
                curNum += 1
            }
            
            rowStart += 1
            
            for j in rowStart...rowEnd {
                arr[j][colEnd] = curNum
                curNum += 1
            }
            
            colEnd -= 1
            
            // 左
            if rowStart <= rowEnd {
                for i in (colEnd - 1)..<colStart {
                    arr[rowEnd][i] = curNum
                    curNum += 1
                }
                rowEnd -= 1
            }
            //上
            if colStart <= colEnd {
                for i in (rowEnd - 1)..<rowStart {
                    arr[i][colStart] = curNum
                    curNum += 1
                }
                colStart += 1
            }
        }
        return arr
    }
    
    func generateMatrix(_ n: Int) -> [[Int]] {
        var matrix = Array(repeating: Array(repeating: 0, count: n), count: n)
        var num = 1
        var left = 0, right = n - 1, top = 0, bottom = n - 1
        
        while left <= right && top <= bottom {
            // left to right
            for i in left...right {
                matrix[top][i] = num
                num += 1
            }
            top += 1

            // right to left
            if top <= bottom {
                // top to bottom
                for i in top...bottom {
                    matrix[i][right] = num
                    num += 1
                }
                right -= 1
                
                for i in stride(from: right, through: left, by: -1) {
                    matrix[bottom][i] = num
                    num += 1
                }
                bottom -= 1
            }
            
            // bottom to top
            if left <= right {
                for i in stride(from: bottom, through: top, by: -1) {
                    matrix[i][left] = num
                    num += 1
                }
                left += 1
            }
        }
        
        return matrix
    }
}

extension Array {
    mutating func mm_shuffle() {
        for i in (1..<count).reversed() {
            let j = Int.random(in: 0..<i)
            print("test->随机: \(i), j: \(j)")
            swapAt(i, j)
        }
        //        for i in stride(from: count - 1, through: 0, by: 1) {
        //            let j = Int(arc4random_uniform(UInt32(i + 1)))
        //            swapAt(i, j)
        //        }
    }
}
