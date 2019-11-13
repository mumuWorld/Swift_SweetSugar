//
//  LeeCodeTrueSubject.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/10/21.x
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class LeetCodeTureSubject {
    
    /// 打家劫舍
    /// https://leetcode-cn.com/problems/house-robber/
    func rob(_ nums: [Int]) -> Int {
        if nums.count <= 1 {
            return nums.first ?? 0
        }
        return 0
    }
}
