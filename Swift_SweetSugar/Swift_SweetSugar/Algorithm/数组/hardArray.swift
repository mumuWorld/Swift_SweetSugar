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



/* 4 7-4 最长递增子序列  https://pintia.cn/problem-sets/1740640628187717632/exam/problems/type/7?problemSetProblemId=1740640696596824068&page=0

 给你一个整数数组nums，找到其中最长严格递增子序列的长度。
 
 子序列 是由数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。例如，[3,6,2,7] 是数组 [0,3,1,6,2,2,7] 的子序列。
 */


func lengthOfLIS(_ nums: [Int]) -> Int {
    // 如果数组为空，返回 0
    guard !nums.isEmpty else { return 0 }
    
    // 创建一个数组来存储每个位置的最长递增子序列的长度
    var dp = Array(repeating: 1, count: nums.count)
    
    // 遍历数组，更新 dp 数组
    for i in 1..<nums.count {
        for j in 0..<i {
            // 只有在当前元素大于前一个元素时，才能形成递增子序列
            if nums[i] > nums[j] {
                dp[i] = max(dp[i], dp[j] + 1)
            }
        }
    }
    
    // 返回 dp 数组中的最大值，即最长递增子序列的长度
    return dp.max()!
}

func start4() {
    let nums = readLine()!.split(separator:" ").compactMap({ Int($0) })
    let result = lengthOfLIS(nums)
    print(result)
}


/* 7-10 超级回文数
 如果一个正整数自身是回文数，而且它也是一个回文数的平方，那么我们称这个数为超级回文数。

 现在，给定两个正整数 L 和 R ，请按照从小到大的顺序打印包含在范围 [L, R] 中的所有超级回文数。

 注：R包含的数字不超过20位

 回文数定义：将该数各个位置的数字反转排列，得到的数和原数一样，例如676，2332，10201。

 输入格式:
 L,R。例如4,1000

 输出格式:
 [L, R]范围内的超级回文数，例如[4, 9, 121, 484]

 输入样例:
 在这里给出一组输入。例如：

 4,1000

 */

func isRightNumb(_ num: Int64) -> Bool {
    let str = String(num)
    return str == String(str.reversed())
}

func findNumbs(_ left: String, _ right: String) {
    guard let lNumb = Int64(left), let rNumb = Int64(right) else { return }
    let magic = 100000
    var result: [Int64] = []
    // 奇数拼接
    for i in 1..<magic {
        let s = String(i)
        let str = s + String(s.dropLast().reversed())
        if let v = Int64(str) {
                let square = v * v
                if square > rNumb {
                    break
                }
                if square >= lNumb, isRightNumb(square) {
                    result.append(square)
                }
            
        }
    }
    
    // 偶数拼接
    for i in 1..<magic {
        let s = String(i)
        let str = s + String(s.reversed())
        if let v = Int64(str) {
                let square = v * v
                if square > rNumb {
                    break
                }
                if square >= lNumb, isRightNumb(square) {
                    result.append(square)
                }
            
        }
    }
    print(result.sorted())
}
func start10() {
    let words: [String] = readLine()!.components(separatedBy: ",")
    findNumbs(words[0], words[1])
    let reuslt = words.sorted { str1, str2 in
        return str1 > str2
    }
}

/*
 7-13 无重复字符的最长子串
 给定一个字符串 s ，请你找出其中不含有重复字符的 最长子串 的长度。

 */
func lengthOfLongestSubstring(_ s: String) -> Int{
    var map: [Character: Int] = [:]
    var maxLength: Int = 0
    var start = 0 // 滑动窗口的起始位置
    
    for (index, char) in s.enumerated() {
        if let preIndex = map[char], preIndex >= start {
            start = preIndex + 1
        }
        map[char] = index
        maxLength = max(maxLength, index - start + 1)
    }
    return maxLength
}

/*
 7-9 最长超赞子字符串
 给你一个字符串 s 。请返回 s 中最长的 超赞子字符串 的长度。
 「超赞子字符串」需满足满足下述两个条件：
 该字符串是 s 的一个非空子字符串
 进行任意次数的字符交换后，该字符串可以变成一个回文字符串
 1 <= s.length <= 10^5
 s 仅由数字组成

 */
func longestAwesome(_ s: String) -> Int {
        let n = s.count
        var prefix: [Int: Int] = [0: -1] // 前缀和与索引的映射
        var ans = 0
        var sequence = 0
        
        // 将字符串转换为字符数组以便遍历
        let characters = Array(s)
        
        for j in 0..<n {
            let digit = Int(String(characters[j]))! // 当前字符转换为数字
            sequence ^= (1 << digit) // 更新序列的奇偶状态
            print("seq: \(sequence), \(j)")
            // 如果当前状态已存在，计算有效子字符串长度
            if let lastIndex = prefix[sequence] {
                ans = max(ans, j - lastIndex)
                print("ans: \(ans)")
            } else {
                prefix[sequence] = j // 记录当前状态的索引
                print("添加: \(sequence), \(j)")
            }
            
            // 检查通过改变一个数字的奇偶状态来得到的新状态
            for k in 0..<10 {
                let newSequence = sequence ^ (1 << k)
                print("k: \(newSequence), \(k)")
                //之前某个位置已经遇到过该状态
                if let lastIndex = prefix[newSequence] {
                    ans = max(ans, j - lastIndex)
                    print("lastIndex: \(lastIndex), \(k), \(ans)")
                }
            }
            print("-----\(prefix)---")
        }
        
        return ans
    }

/*
 7-7 不相交的线
 在两条独立的水平线上按给定的顺序写下 nums1 和 nums2 中的整数。

 现在，可以绘制一些连接两个数字 nums1[i] 和 nums2[j] 的直线，这些直线需要同时满足满足：

 nums1[i] == nums2[j]

 且绘制的直线不与任何其他连线（非水平线）相交。

 请注意，连线即使在端点也不能相交：每个数字只能属于一条连线。

 以这种方法绘制线条，并返回可以绘制的最大连线数。

 1 <= nums1.length, nums2.length <= 500

 1 <= nums1[i], nums2[j] <= 2000
 */

func maxUncrossedLines(_ nums1: [Int], _ nums2: [Int]) -> Int {
    let m = nums1.count
    let n = nums2.count
    var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
    
    for i in 1...m {
        for j in 1...n {
            if nums1[i - 1] == nums2[j - 1] {
                dp[i][j] = dp[i - 1][j - 1] + 1
            } else {
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
            }
        }
    }

    return dp[m][n]
}

/*
 7-11 最多能完成排序的块
 给你一个整数数组 arr 。将 arr 分割成若干 块 ，并将这些块分别进行排序。之后再连接起来，使得连接的结果和按升序排序后的原数组相同。

 返回能将数组分成的最多块数？

 输入格式:
 1. 输入整数数列，元素之间以空格分开

 2. 其中数组长度为n，1<=n<=1000,

 3. 数组元素 1 <= arr[i], k <= 100，数组元素可有重复整数

 输出格式:
 数组能分成的最多块数
 */
func maxChunksToSorted(_ arr: [Int]) -> Int {
   var stack = [Int]()
    for num in arr {
        if stack.isEmpty || num >= stack.last! {
            stack.append(num)
        } else {
            let tmp = stack.removeLast()
            while !stack.isEmpty && stack.last! > num {
                stack.removeLast()
            }
            stack.append(tmp)
        }
    }
    return stack.count
}

extension HardArray {
    
    func start7() {
        
    }
    
    func start9() {
        let result = longestAwesome("3242415")
        print("ans:11 \(result)")
        
    }
}
