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
        mm_printLog("mid->\(mid)")
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
    
    
    func mergeSort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else {
            return array
        }
        let middleIndex = array.count / 2
        let leftArray = mergeSort(Array(array[0..<middleIndex]))
        let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
        return merge(leftArray, rightArray)
    }

    func merge<T: Comparable>(_ leftArray: [T], _ rightArray: [T]) -> [T] {
        var mergedArray: [T] = [] // 创建一个空数组，用于存储合并后的结果
        var leftIndex = 0 // 左数组的索引
        var rightIndex = 0 // 右数组的索引
        // 循环比较左右两个数组的元素，直到其中一个数组的元素全部被合并
        while leftIndex < leftArray.count && rightIndex < rightArray.count {
            // 比较左右数组的元素大小，将较小的元素添加到结果数组中
            if leftArray[leftIndex] < rightArray[rightIndex] {
                mergedArray.append(leftArray[leftIndex])
                leftIndex += 1
            } else {
                mergedArray.append(rightArray[rightIndex])
                rightIndex += 1
            }
        }
        // 将左数组或右数组中剩余的元素添加到结果数组中
        mergedArray += leftArray[leftIndex...]
        mergedArray += rightArray[rightIndex...]
        return mergedArray
    }
    
}
