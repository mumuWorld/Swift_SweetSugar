//
//  Test_Tmp.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/10/11.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation


class Test_Tmp2 {
    func test() {
        var dict: [Int: Int] = [0:11, 1:22, 2:33]
//        test->0, (key: 1, value: 22)
//        test->1, (key: 2, value: 33)
//        test->2, (key: 0, value: 11)
        // 不要使用此方法
        for (k, v) in dict.enumerated() {
            print("test->\(k), \(v)")
        }
        
        for (k, v) in dict {
            print("test->\(k), \(v)")
        }
    }
//
//    class UnionFind {
//        var parent: [Int] = []
//        var size: [Int] = []
//        
//        init (_ n: Int) {
//            parent = Array(0..<n)
//            size = Array(repeating: 1, count: n)
//        }
//
//        func find(_ num: Int) {
//            if parent[num] != num {
//                return find(parent[num])
//            }
//            return parent[num]
//        }
//
//        func merge(_ num1: Int, _ num2: Int) {
//            let vNum1 = find(num1)
//            let vNum2 = find(num2)
//            if vNum1 != vNum2 {
//                if size[vNum2] > size[vNum1] {
//                    parent[vNum1] = vNum2
//                    size[vNum2] += size[vNum1]
//                } else {
//                    parent[vNum2] = vNum1
//                    size[vNum1] += size[vNum2]
//                }
//
//            }
//        }
//    }
//    
//    func test() {
//        
//        let arr = readLine()!.split(separator:" ").compactMap({ Int($0)! })
//        let uf = UnionFind(arr.max()! + 1)
//
//        for num in arr {
//            var tmpN = 2
//            while tmpN * tmpN <= num {
//                if num % tmpN == 0 {
//                    uf.merge(num, tmpN)
//                uf.merge(num, num / tmpN)
//                }
//                tmpN += 1
//            }
//        }
//        var cache: [Int: Int] = [:]
//        var maxCount: Int = 0
//        for num in arr {
//            let root = uf.find(num)
//            cache[root, default: 0] += 1
//            maxCount = max(maxCount, cahce[root] ?? 0)
//        }
//
//        print(maxCount)
//    }
//    
//    
}

