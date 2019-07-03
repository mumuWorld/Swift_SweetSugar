//
//  Solution.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/7/3.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class Solution {
    
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
}
