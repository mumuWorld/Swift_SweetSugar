//
//  StringSolution.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/7/4.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation
import UIKit

class StringSolution {
    /// 无重复最长子串 哈希表
    /// https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/
    func lengthOfLongestSubstring(_ s: String) -> Int {
//        let time = CACurrentMediaTime()
        let n = s.count
        var ans = 0
        var i = 0
        var j = 0
        var map = Dictionary<Character, Int>()
        
        while j < n {
//            let startIndex = s.index(s.startIndex, offsetBy: j)
//
//            let endIndex = s.index(after: startIndex)
//            let str = s[startIndex..<endIndex]
//
//            let char = Character(str)
            let char = s[s.index(s.startIndex, offsetBy: j)]
            print(char)
            if let index = map[char] {
                i = max(index, i)
            }
            ans = max(ans, j - i + 1)
            map[char] = j+1
            j += 1
//            print("end= \(CACurrentMediaTime() - start)")
        }
//        let endTime = CACurrentMediaTime() - time
//        print("endtime= \(endTime)")
        return ans
    }
    
    /// 最长回文子串
    ///https://leetcode-cn.com/problems/longest-palindromic-substring/submissions/
    func longestPalindrome(_ s: String) -> String {
        let time = CACurrentMediaTime()
        if s.isEmpty {
        return ""
        }
        var start = 0,end = 0
        for i in 0...s.count {
            let len1 = expandAroundCenter(s: s, left: i, right: i)
            let len2 = expandAroundCenter(s: s, left: i, right: i+1)
            let len = max(len1, len2)
            if len > end - start {
                start = i - (len - 1)/2
                end = i + len/2
            }
            
        }
        let lIndex = s.index(s.startIndex, offsetBy: start)
        let rIndex = s.index(s.startIndex, offsetBy: (end+1))
        let result = s[lIndex..<rIndex]
                let endTime = CACurrentMediaTime() - time
                print("endtime= \(endTime)")
        return String(result)
        
    }
    private func expandAroundCenter(s: String,left:Int, right:Int) ->Int {
        var L = left,R = right
        while( L >= 0 && R < s.count) && s[s.index(s.startIndex,offsetBy: L)] == s[s.index( s.startIndex,offsetBy: R)] {
            L -= 1;
            R += 1;
        }
        // 这里要特别小心，跳出 while 循环的时候，是第 1 个满足 s.charAt(l) != s.charAt(r) 的时候
        // 所以，不能取 l，不能取 r
        
        return R - L - 1
        
    }
}

