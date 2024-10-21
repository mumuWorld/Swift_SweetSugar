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
     7-6 计算岛屿最大面积

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
 7-1 按格式合并两个链表
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

 https://leetcode.cn/problems/create-maximum-number/description/
 */


func test3() {
    
    // 从单个数组中选出 t 个数，保持相对顺序，得到最大的数
    func maxSubsequence(_ nums: [Int], _ t: Int) -> [Int] {
        var stack = [Int]()
        var drop = nums.count - t
        for num in nums {
            // drop > 0
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
            // 合并直接用compare
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
            // 注意这里是<=
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
    
    // 遍历数组，更新 dp 数组, 从1开始
    for i in 1..<nums.count {
        // 从0 到 <i
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

/*
 7-5 二叉树的最大路径和

 二叉树中的 路径 被定义为一条节点序列，序列中每对相邻节点之间都存在一条边。同一个节点在一条路径序列中 至多出现一次 。该路径 至少包含一个 节点，且不一定经过根节点。
 路径和 是路径中各节点值的总和。
 给你一个二叉树的根节点 root ，返回其 最大路径和 。

 输入格式:
 树上的节点数满足 0 <= n <= 1000, 每个节点的值满足 -1000 <= val <= 1000

 （注：null节点的左右叶子不会再打印null）

 输出格式:
 输出最大路径的和


 输入样例:
 在这里给出一组输入。例如：

 -10,9,20,null,null,15,7
 */

//class TreeNode {
//    var val: Int
//    var left: TreeNode?
//    var right: TreeNode?
//    init(_ val: Int) {
//        self.val = val
//        self.left = nil
//        self.right = nil
//    }
//}

func createBinaryTree(_ nodes: [String]) -> TreeNode? {
    
    if nodes.isEmpty == true { // 使用-9999作为null的占位符
        return nil
    }
    let nodeValue = Int(nodes[0])
    let node = TreeNode(nodeValue!)
    var queue: [TreeNode] = [node]
    var index = 1
    while queue.isEmpty == false && index < nodes.count {
        let current = queue.removeFirst()
        if index < nodes.count, nodes[index] != "null" {
            let leftNode = TreeNode(Int(nodes[index])!)
            current.left = leftNode
            queue.append(leftNode)
        }
        index += 1
        
        // 构建右子节点
        if index < nodes.count, nodes[index] != "null" {
            let rightNode = TreeNode(Int(nodes[index])!)
            current.right = rightNode
            queue.append(rightNode)

        }
        index += 1
    }
    return node
}

var sum: Int = 0
func dfs(_ node: TreeNode?) -> Int? {
    guard let node else { return nil }
    let leftSum = max(dfs(node.left) ?? 0, 0)
    let rightSum = max(dfs(node.right) ?? 0, 0)
    let curSum = node.val + leftSum + rightSum
    sum = max(curSum, sum)
    return node.val + max(leftSum, rightSum)
}

func start() {
    // 将字符串转换为数组，null用-9999代替
let data: [String] = readLine()!.split(separator: ",").compactMap({ String($0) })
    let root = createBinaryTree(data)
    let _ = dfs(root)
    print(sum)
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
思路分别 从奇数和偶数 的一半创建回文数，
 1 然后求这个数的平方 是否超出右边，
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

func testtest(_ s: String) {
    var preDict: [Int: Int] = [0: -1]
    var result = 0
    let characters = Array(s).compactMap({ Int(String($0))})
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
 输入样例1:
 在这里给出一组输入。例如：
 abcabcbb
 
 输出样例1:
 在这里给出相应的输出。例如：
 3
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
        // 通过异或 来判断奇偶状态
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
    // 获取 nums1 和 nums2 的长度
    let m = nums1.count
    let n = nums2.count
    
    // 创建一个二维数组 dp，大小为 (m + 1) x (n + 1)
    // dp[i][j] 表示 nums1 的前 i 个元素与 nums2 的前 j 个元素之间
    // 最多能够画出多少不相交的线。初始值都为 0
    var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
    
    // 遍历 nums1 和 nums2 的所有元素
    for i in 1...m {
        for j in 1...n {
            // 如果 nums1[i-1] 和 nums2[j-1] 相等，表示可以画出一条线
            // 同时该线与之前的线不相交，因此将 dp[i-1][j-1] 的值加 1
            if nums1[i - 1] == nums2[j - 1] {
                dp[i][j] = dp[i - 1][j - 1] + 1
            } else {
                // 如果元素不相等，不能画线，因此取上一个状态的最大值
                // 要么忽略 nums1[i-1]，那么看 dp[i-1][j]
                // 要么忽略 nums2[j-1]，那么看 dp[i][j-1]
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
            }
        }
    }

    // 最终 dp[m][n] 存储的是 nums1 和 nums2 之间最多能够画出的不相交线的数量
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
 
 1.    使用一个栈 stack 来维护当前处理的最大块。当我们遍历数组 arr 时，如果当前元素 num 大于等于栈顶元素（即 stack.last!），说明当前元素可以加入这个块，保持块内元素有序。因此直接将 num 压入栈中。
     2.    如果当前元素 num 小于栈顶元素，说明当前块需要与前面的块合并，因为此时必须打破当前块的顺序性。此时，我们做以下几件事：
     •    首先，弹出栈顶元素，并将其暂时存储在变量 tmp 中，这表示我们将合并的块的最大值。
     •    然后，不断弹出栈顶元素，直到找到一个栈顶元素小于或等于当前元素 num 为止。这个过程就是不断合并前面的块。
     •    最后，将 tmp 压回栈中，确保合并后的块的最大值保持不变。
     3.    遍历结束后，栈的大小即为可以分块的数量。
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

/*
 7-12 最长有效括号
 
 给你一个只包含 '(' 和 ')' 的字符串，找出最长有效（格式正确且连续）括号子串的长度。

 输入格式:
 包含 '(' 和 ')' 的字符串

 输出格式:
 有效括号子串的长度

 输入样例1:
 在这里给出一组输入。例如：

 (()
 输出样例1:
 在这里给出相应的输出。例如：

 */
func longestValidParentheses(_ s: String) -> Int {
        var maxLength = 0
        var stack = [-1] // 初始化栈，包含一个初始值 -1
        
        for (index, char) in s.enumerated() {
            if char == "(" {
                // 如果是左括号，将其索引压入栈中
                stack.append(index)
                // print("push:\(index)")
            } else {
                // 如果是右括号，将栈顶元素弹出
                stack.removeLast()
                // print("removeLast:\(index)")
                if stack.isEmpty {
                    // 如果栈为空，将当前右括号的索引压入栈
                    stack.append(index)
                    // print("push2: \(index), \(stack)")
                } else {
                    // 否则，计算有效子串的长度
                    maxLength = max(maxLength, index - stack.last!)
                                        // print("计算: \(index),\(maxLength)")
                }
            }
        }
        
        return maxLength
    }

/* 7-14 按位与为零的三元组

 给你一个整数数组 nums ，返回其中 按位与三元组 的数目。

 按位与三元组 是由下标 (i, j, k) 组成的三元组，并满足下述全部条件：

 0 <= i < nums.length

 0 <= j < nums.length

 0 <= k < nums.length

 nums[i] & nums[j] & nums[k] == 0 ，其中 & 表示按位与运算符。

 提示：

 1 <= nums.length <= 1000

 0 <= nums[i] < 2^16

 注意：时间复杂度是 O(n^3)的算法，会超出时间限制。
 */

func countTriplets(_ nums: [Int]) -> Int {
    var count = 0
    var andResults = [Int: Int]()
    
    // 枚举前两个数的按位与结果，并统计这些结果出现的次数
    for i in 0..<nums.count {
        for j in 0..<nums.count {
            let andValue = nums[i] & nums[j]
            andResults[andValue, default: 0] += 1
        }
    }

    // 枚举第三个数，检查与之前的按位与结果是否为 0
    for k in 0..<nums.count {
        for (andValue, frequency) in andResults {
            if (andValue & nums[k]) == 0 {
                count += frequency
            }
        }
    }
    
    return count
}

/*
 7-8 解码异或后的排列

 给你一个整数数组 perm ，它是前 n 个正整数（1,2,3,4,5,…,n-1,n 共n个正整数）的排列，且 n 是个奇数 。

 它被加密成另一个长度为 n-1 的整数数组 encoded ，满足 encoded[i] = perm[i] XOR perm[i+1]。比方说，如果 perm=[1,3,2] ，那么 encoded=[2,1]。

 给你 encoded 数组，请你返回原始数组 perm 。题目保证答案存在且唯一。

 提示：

 n 是奇数。

 3 <= n < 10^5

 encoded.length == n - 1

 输入格式:
 整数数组encoded，以",”分隔字符串形式作为输入

 输出格式:
 解码后的原始整数数组perm，以",”分隔字符串形式作为输出
 */

func decode(_ encoded: [Int]) -> [Int] {
    let n = encoded.count + 1
    var totalXOR = 0
    var oddXOR = 0
    
    // 计算 totalXOR: 1 到 n 的全部异或
    for i in 1...n {
        totalXOR ^= i
    }
    
    // 计算 oddXOR: encoded 中所有奇数下标元素的异或
    for i in 1..<encoded.count {
        if i % 2 != 0 {
            oddXOR ^= encoded[i]
        }
    }
    
    // 计算 perm[0]
    var perm = [Int](repeating: 0, count: n)
    perm[0] = totalXOR ^ oddXOR
    
    // 依次计算 perm[i]，通过 encoded[i-1] = perm[i-1] XOR perm[i]
    for i in 1..<n {
        perm[i] = perm[i-1] ^ encoded[i-1]
    }
    
    return perm
    
}

//
//// 解析输入和输出
//if let input = readLine() {
//    let encoded = input.split(separator: ",").compactMap { Int($0) }
//    let result = decode(encoded)
//    print(result.map { String($0) }.joined(separator: ","))
//}


/*
 7-2 按公因数计算最大组件大小

 给定一个由不同正整数组成的非空数组 nums，考虑下面的构图：

 有 nums.length 个节点，按照从 nums[0]到 nums[nums.length-1]标记；

 只有当 nums[i] 和 nums[j] 共用一个大于 1 的公因数时，nums[i] 和 nums[j] 之间才有一条边。

 返回构图中最大连通组件的大小。

 输入格式:
 输入为数组元素，空格分隔

 输出格式:
 输出最大连通组件的大小

 输入样例1:
 在这里给出一组输入。例如：

 4 6 15 35
 */

class UnionFind {
    private var parent: [Int]
    private var size: [Int]
    
    init(_ n: Int) {
        parent = Array(0..<n)
        size = Array(repeating: 1, count: n)
    }
    
    func find(_ x: Int) -> Int {
        if parent[x] != x {
            parent[x] = find(parent[x])  // 路径压缩
        }
        return parent[x]
    }
    
    func union(_ x: Int, _ y: Int) {
        let rootX = find(x)
        let rootY = find(y)
        
        if rootX != rootY {
            if size[rootX] > size[rootY] {
                parent[rootY] = rootX
                size[rootX] += size[rootY]
            } else {
                parent[rootX] = rootY
                size[rootY] += size[rootX]
            }
        }
    }
}

func largestComponentSize(_ nums: [Int]) -> Int {
    let maxNum = nums.max() ?? 0
    let uf = UnionFind(maxNum + 1)
    
    // 将具有共同因数的数连在一起
    for num in nums {
        var factor = 2
        while factor * factor <= num {
            if num % factor == 0 {
                uf.union(num, factor)
                uf.union(num, num / factor)
            }
            factor += 1
        }
    }
    
    // 统计每个根节点的连通分量的大小
    var componentCount = [Int: Int]()
    var maxSize = 0
    for num in nums {
        let root = uf.find(num)
        componentCount[root, default: 0] += 1
        maxSize = max(maxSize, componentCount[root]!)
    }
    
    return maxSize
}

//// 解析输入和输出
//if let input = readLine() {
//    let nums = input.split(separator: " ").compactMap { Int($0) }
//    let result = largestComponentSize(nums)
//    print(result)
//}


extension HardArray {
    
    func start7() {
        
    }
    
    func start9() {
        let result = longestAwesome("3242415")
        print("ans:11 \(result)")
        
        let size = largestComponentSize([4, 6, 15, 35])
        print("ans:11 \(size)")
    
    }
}

