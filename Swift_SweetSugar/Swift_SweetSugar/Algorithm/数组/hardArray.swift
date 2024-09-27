//
//  hardArray.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/9/27.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation
class HardArray {
    func start() {
        // 读取输入
        var array2D: [[Int]] = []
        if let input = readLine() {
            // 将字符串处理为二维数组
            array2D = (input as NSString)
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "[", with: "")  // 去掉左方括号
                .replacingOccurrences(of: "]", with: "")  // 去掉右方括号
                .components(separatedBy: ";")             // 通过分号分割字符串，得到每一行
                .map { row in
                    row.split(separator: ",").compactMap { Int($0) } // 将每行转换为整数数组
                }

            // 打印二维数组
            print(array2D)
        }
    }
    
    // 读取输入
    func maxLand() {
        var array2D: [[Int]] = []
        if let input = readLine() {
            // 将字符串处理为二维数组
            array2D = input
                .replacingOccurrences(of: "[", with: "")  // 去掉左方括号
                .replacingOccurrences(of: "]", with: "")  // 去掉右方括号
                .components(separatedBy: ";")             // 通过分号分割字符串，得到每一行
                .map { row in
                    row.split(separator: ",").compactMap { Int($0) } // 将每行转换为整数数组
                }
            
            let result = maxAreaOfIsland(array2D)
            print(result)
        }
        
        
    }
    /*
     1.    DFS 函数 dfs：从某个格子开始，如果它是 1（陆地），我们将它标记为 0（水），以避免重复访问。然后递归地访问它的四个相邻格子，并将每个相邻格子的面积加到当前面积中。
     2.    网格遍历：我们遍历整个网格，找到每一个未访问的 1，并从它开始执行 DFS 计算它所连通的岛屿的面积。
     3.    最大面积计算：对于每一个岛屿的面积，我们与当前最大面积进行比较，记录最大的那个。
     */
    /// 最大岛屿面积
    func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
        var grid = grid // 复制一份可变的 grid
        let m = grid.count
        let n = grid[0].count
        var maxArea = 0
        
        // 定义 DFS 函数
        func dfs(_ i: Int, _ j: Int) -> Int {
            // 检查边界条件以及是否为水或者已经访问过的格子
            if i < 0 || i >= m || j < 0 || j >= n || grid[i][j] == 0 {
                return 0
            }
            
            // 标记为已访问（设为 0 表示水）
            grid[i][j] = 0
            
            // 计算当前格子本身面积为 1，然后向四个方向扩展
            return 1 + dfs(i + 1, j) + dfs(i - 1, j) + dfs(i, j + 1) + dfs(i, j - 1)
        }
        
        // 遍历网格
        for i in 0..<m {
            for j in 0..<n {
                if grid[i][j] == 1 {
                    // 对每个岛屿计算面积
                    maxArea = max(maxArea, dfs(i, j))
                }
            }
        }
        
        return maxArea
    }
}


/*
 给定两个链表L1​=a1​→a2​→⋯→an−1​→an​ 和L2​=b1​→b2​→⋯→bm−1​→bm​，其中n≥2m。

 需要将较短的链表L2​反转并合并到较长的链表L1​中

 使得合并后的链表如下形式：a1​→a2​→bm​→a3​→a4​→bm−1​→…

 合并规则：在长链表中每隔两个元素，将短链表中的元素倒序插入。

 例如：给定一个较长链表1→2→3→4→5，另外一个较短链表6→7，需要输出1→2→7→3→4→6→5

 输入格式:
 第一行包含两个链表的第一个节点地址（不确定哪个链表更长），以及两个链表的总节点数N(≤100000)。

 节点地址用一个 5 位非负整数表示（可能有前导 0），空地址 NULL 用 −1 表示。

 例如：00100 01000 7。其中00100表示第一个链表的首个节点地址，01000表示第二个链表的首个节点地址，7表示两个链表的总节点数。

 接下来N行，每行描述一个节点的信息，格式如下：

 Address Data Next

 其中 Address 是节点地址，Data 是一个绝对值不超过100000的整数，Next 是下一个节点的地址。

 保证两个链表都不为空，且较长的链表至少是较短链表长度的两倍。

 输出格式:
 对于每个测试用例，按顺序输出合并后的结果链表。每个结点占一行，按输入的格式输出。
 00100 01000 7
 02233 2 34891
 00100 6 00001
 34891 3 10086
 01000 1 02233
 00033 5 -1
 10086 4 00033
 00001 7 -1
 */

class InputModel {
    var address: Int = 0
    var data: Int = 0
    var next: Int = 0
    
    var nextModel: InputModel?
    
    init(address: Int, data: Int, next: Int) {
        self.address = address
        self.data = data
        self.next = next
    }
}
    
    func megreList(list1: [Int], list2: [Int], nodesDict: [Int: InputModel]) -> [Int] {
        var longIndex = 0
        var shortIndex = 0
        let shortCount = list2.count
        var mergedList: [Int] = []

        while longIndex < list1.count {
            mergedList.append(list1[longIndex])
            longIndex += 1
            if longIndex < list1.count {
                mergedList.append(list1[longIndex])
                longIndex += 1
            }
            if shortIndex < shortCount {
                mergedList.append(list2[shortIndex])
                shortIndex += 1
            }
        }
        for i in 0..<mergedList.count - 1 {
            nodesDict[mergedList[i]]!.next = mergedList[i + 1]
        }
        nodesDict[mergedList.last!]?.next = -1
        return mergedList
    }

func startList() {
    var firstAddress: Int = 0
    var secAddress: Int = 0
    // var sumCount: Int = 0
    
    // 读取第一行
    if let text = readLine() {
        let arr = text.components(separatedBy: " ")
        firstAddress = Int(arr[0])!
        secAddress = Int(arr[1])!
        // sumCount = Int(arr[2])!
    }
    
    var dict = [Int: InputModel]()

    while let text = readLine() {
        let arr = text.components(separatedBy: " ")
        let address = Int(arr[0])!
        let data = Int(arr[1])!
        let next = Int(arr[2])!
        
        dict[address] = InputModel(address: address, data: data, next: next)
    }
    
    func buileList(dict: [Int: InputModel], headAddresss: Int) -> [Int] {
        var list: [Int] = []
        var cur = headAddresss
        while cur != -1 {
            list.append(cur)
            cur = dict[cur]!.next
        }
        return list
    }
    // 构建两个链表
    let list1 = buileList(dict: dict, headAddresss: firstAddress)
    let list2 = buileList(dict: dict, headAddresss: secAddress)
    
    var longList: [Int] = list1
    var shotList: [Int] = list2
    if list1.count < list2.count {
        longList = list2
        shotList = list1
    }
    
    // 反转链表函数
    func reverseList(head: Int, nodesDict: [Int: InputModel]) -> Int {
        var prev: Int = -1
        var current: Int = head
        
        while current != -1 {
            let nextNode = nodesDict[current]!.next
            nodesDict[current]!.next = prev
            prev = current
            current = nextNode
        }
        return prev
    }
    
    let reversedShortListHead = reverseList(head: shotList[0], nodesDict: dict)
    shotList = buileList(dict: dict, headAddresss: reversedShortListHead)
    
    let result = megreList(list1: longList, list2: shotList, nodesDict: dict)
    for item in result {
        let model = dict[item]!
        if model.next == -1 {
            print(String(format: "%05d %d -1", model.address, model.data))
        } else {
            print(String(format: "%05d %d %05d", model.address, model.data, model.next))
        }
    }
}


/* 7-3 拼接最大数
 给定长度分别为 m 和 n 的两个数组，其元素由 0-9 构成，表示两个自然数各位上的数字。

 现在从这两个数组中选出 k (0 <=k <= m + n) 个数字拼接成一个新的数，要求从同一个数组中取出的数字保持其在原数组中的相对顺序。
 求满足该条件的最大数。结果返回一个表示该最大数的长度为 k 的数组。
 
 
 1.    maxSubsequence(nums, t)：从数组 nums 中选出长度为 t 的最大子序列。通过贪心算法使用栈来实现，保持相对顺序的情况下，选出最大的数。
 2.    merge(nums1, nums2)：将两个子序列合并成一个最大序列。通过双指针比较每个位置的值，依次选择更大的值加入到结果数组中。
 3.    compare(nums1, i, nums2, j)：比较两个数组从 i 和 j 开始的子数组，哪个更大。用于在合并数组时做出决策。
 4.    maxNumber(nums1, nums2, k)：主函数，枚举从数组1中选出 i 个数，数组2中选出 k-i 个数，合并后得到最大数。

 */


func test3() {
    
    // 从单个数组中选出 t 个数，保持相对顺序，得到最大的数
    func maxSubsequence(_ nums: [Int], _ t: Int) -> [Int] {
        var stack = [Int]()
        var drop = nums.count - t
        for num in nums {
            while drop > 0 && !stack.isEmpty && stack.last! < num {
                stack.removeLast()
                drop -= 1
            }
            stack.append(num)
        }
        return Array(stack.prefix(t))
    }

    // 合并两个数组，得到尽可能大的数
    func merge(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        var result = [Int]()
        var i = 0, j = 0
        while i < nums1.count || j < nums2.count {
            if compare(nums1, i, nums2, j) {
                result.append(nums1[i])
                i += 1
            } else {
                result.append(nums2[j])
                j += 1
            }
        }
        return result
    }

    // 比较两个数组从 i 和 j 开始的子数组哪个更大
    func compare(_ nums1: [Int], _ i: Int, _ nums2: [Int], _ j: Int) -> Bool {
        var i = i, j = j
        while i < nums1.count && j < nums2.count {
            if nums1[i] != nums2[j] {
                return nums1[i] > nums2[j]
            }
            i += 1
            j += 1
        }
        return i < nums1.count
    }

    // 主函数
    func maxNumber(_ nums1: [Int], _ nums2: [Int], _ k: Int) -> [Int] {
        var result = [Int]()
        let m = nums1.count, n = nums2.count
        for i in 0...k {
            if i <= m && k - i <= n {
                let subsequence1 = maxSubsequence(nums1, i)
                let subsequence2 = maxSubsequence(nums2, k - i)
                let candidate = merge(subsequence1, subsequence2)
                if compare(candidate, 0, result, 0) {
                    result = candidate
                }
            }
        }
        return result
    }
    let nums1 = readLine()!.split(separator: ",").compactMap({ Int($0)})
    let nums2 = readLine()!.split(separator: ",").compactMap({ Int($0)})
    let k = Int(readLine()!) ?? 0
//    // 测试用例
//    let nums1 = [3, 4, 6, 5]
//    let nums2 = [9, 1, 2, 5, 8, 3]
//    let k = 5
    let result = maxNumber(nums1, nums2, k)
    let str = result.map({ String($0) }).joined(separator: ",")
    print(str)
//    print(maxNumber(nums1, nums2, k)) // 输出 [9, 8, 6, 5, 3]
}
