//
//  BaseSort.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/9/27.
//  Copyright © 2019 Mumu. All rights reserved.
//

import UIKit

class BaseSort {
    
    class func popSort(arr: inout [Int]) -> [Int] {
        /// 记录最后一次交换的位置
        var indexI = arr.count - 1
        while indexI > 0 {
            var compareIndex = 1
            var indexJ:Int =  0
            while indexJ < indexI, indexI > 0  {
                print("IndexI = \(indexI)")
                if arr[indexJ] > arr[indexJ + 1] {
                    exchangeItem(arr: &arr, oneIndex: indexJ, twoIndex: indexJ + 1)
                    compareIndex = indexJ + 1
                    print("compareIndex=",compareIndex)
                    
                }
                indexJ += 1
            }
            indexI = compareIndex
            print(arr)
            indexI -= 1
        }
        return arr
    }
    
    class func exchangeItem(arr:inout [Int], oneIndex: Int, twoIndex: Int) -> Void {
        let tmp = arr[oneIndex]
        arr[oneIndex] = arr[twoIndex]
        arr[twoIndex] = tmp
    }
}
