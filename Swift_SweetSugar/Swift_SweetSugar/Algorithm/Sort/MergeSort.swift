//
//  MergeSort.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/11/22.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class MergeSort<E>: Sort<E>  where E: Comparable {
    var leftArr: [E]
    
    override init() {
        leftArr = Array()
        super.init()
    }
    
    override init(arr: [E]) {
        leftArr = arr
        super.init(arr: arr)
    }
    
    override func sort() -> [E] {
        sort(begin: 0, end: elelments.count)
        return elelments
    }
    
    func sort(begin: Int, end: Int) -> Void {
        if end - begin < 2 {
            return
        }
        let mid = (begin + end) >> 1
        mm_printLog(message: "mid->\(mid)")
        sort(begin: begin, end: mid)
        sort(begin: mid, end: end)
        merge(begin: begin, mid: mid, end: end)
    }
    
    func merge(begin: Int, mid: Int, end: Int) -> Void {
        var li = 0, le = mid - begin //左边数组
        var ri = mid, re = end
        var ai = begin
        
        for index in li..<le {
            leftArr[index] = elelments[begin + index]
        }
        while li < le { //如果左边还没有结束
            if ri < re && elelments[ri] < leftArr[li] {
                elelments[ai] = elelments[ri]
                ai += 1
                ri += 1
            } else {
                elelments[ai] = leftArr[li]
                ai += 1
                li += 1
            }
        }
        
    }
}
