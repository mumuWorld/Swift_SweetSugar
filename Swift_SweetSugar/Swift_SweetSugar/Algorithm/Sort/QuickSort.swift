//
//  QuickSort.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/11/21.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class QuickSort<E> where E: Comparable{
    private var elelments: [E]
    
    init() {
        elelments = Array()
    }
    
    convenience init(sortArr: [E]) {
        self.init()
        elelments = sortArr
    }
    
    func sort(arr: [E]) -> [E] {
        elelments = arr
        realSort(begin: 0, end: elelments.count)
        return elelments
    }
    
    func realSort(begin: Int, end: Int) -> Void {
        if end - begin < 2 {
            return
        }
        let mid = findPivotIndex(begin: begin, end: end)
        realSort(begin: begin, end: mid)
        realSort(begin: mid + 1, end: end)
    }
    
    func findPivotIndex(begin: Int, end: Int) -> Int {
        //随机轴点index
//        let randomIndex = begin + Int(arc4random()) % (end - begin)
        let randomIndex = begin + Int(arc4random_uniform(UInt32(end - begin)))
        elelments.swapAt(randomIndex, begin)
        //去除轴点元素
        let pivot = elelments[begin]
        var tBegin = begin
        //因为是左闭右开 所以进行边界 - 1
        var tEnd = end - 1
        while tBegin < tEnd {
            while tBegin < tEnd {
                if pivot <= elelments[tEnd] {
                    tEnd -= 1
                } else {
                    elelments[tBegin] = elelments[tEnd]
                    tBegin += 1
                    break
                }
            }
            while tBegin < tEnd {
                if elelments[tBegin] < pivot {
                    tBegin += 1
                } else {
                    elelments[tEnd] = elelments[tBegin]
                    tEnd -= 1
                    break
                }
            }
        }
        elelments[tBegin] = pivot
        mm_printLog(elelments)
        return tBegin
    }

}

