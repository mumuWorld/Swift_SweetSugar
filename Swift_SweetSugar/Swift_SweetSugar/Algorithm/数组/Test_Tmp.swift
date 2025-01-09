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

class Node {
    var key: Int = 0
    var val: Int = 0
    var next: Node?
    var head: Node?
}

class LRUCacheTest2 {

    var map: [Int: Node] = [:]
    var head: Node?
    var trail: Node?

    var limitCap: Int = 0

    init(_ capacity: Int) {
        limitCap = capacity
    }
    
    func get(_ key: Int) -> Int {
        if let node = map[key] {
            moveToHead(node)
            return node.val
        }
        return -1
    }
    
    func put(_ key: Int, _ value: Int) {
        if let node = map[key] {
            node.val = value
            moveToHead(node)
        } else {
            if map.count >= limitCap, let tailNode = removeTail() {
                map.removeValue(forKey: tailNode.key)
            }
            let node = Node()
            node.val = value
            node.key = key
            map[key] = node
            addToHead(node)
        }
    }
    
    func addToHead(_ node: Node) {
        node.next = head
        node.head = nil

        if head == nil {
            trail = node
        } else {
            head?.head = node
        }

        head = node
    }

    func moveToHead(_ node: Node) {
        if node !== head {
            let prev = node.head
            let next = node.next

            prev?.next = next
            next?.head = prev

            node.next = head
            node.head = nil

            if node === trail {
                trail = prev
            }

            head?.head = node
            head = node
        }
    }

    func removeTail() -> Node? {
        let currentTail = trail

        if trail === head {
            trail = nil
            head = nil
        } else {
            trail = trail?.head
            trail?.next = nil
        }

        return currentTail
    }
    
    
    static func test() {
        let cache = LRUCacheTest2(2)
        cache.put(1, 1)
        cache.put(2, 2)
        print(cache.get(1))
        cache.put(3, 3)
        print(cache.get(2))
        cache.put(4, 4)
        print(cache.get(1))
        print(cache.get(3))
        print(cache.get(4))
    }
}

class Solution2 {
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        let arr = Array(word)
        let rowCount = board[0].count
        let columnCount = board.count
        
        var visited: [[Int]] = Array(repeating: Array(repeating: 0, count: rowCount + 1), count: columnCount + 1)
        
        func check(row: Int, column: Int, offset: Int) -> Bool {
            if board[column][row] != arr[offset] {
                return false
            } else if offset == word.count - 1 {
                return true
            }
            visited[column][row] = 1
            let arr = [(column + 1, row), (column, row + 1), (column - 1, row), (column, row - 1)]
            for i in arr {
                let c = i.0
                let r = i.1
                if c >= 0 && c < columnCount && r >= 0 && r < rowCount && visited[c][r] == 0 {
                    if check(row: r, column: c, offset: offset + 1) {
                        visited[column][row] = 0
                        return true
                    }
                }
            }
            visited[column][row] = 0
            return false
        }
        for i in 0..<columnCount {
            for j in 0..<rowCount {
                if board[i][j] == arr.first {
                    if check(row: j, column: i, offset: 0) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    /*
     https://leetcode.cn/problems/combinations/solutions/405094/zu-he-by-leetcode-solution/
     */
    func combine(n: Int, k: Int) -> [[Int]] {
        
        var answer: [[Int]] = []
        var tmp: [Int] = []
        
        func dfs(index: Int) {
            // 数量不够，直接return
            if tmp.count + (n - index + 1) < k {
                return
            }
            if tmp.count == k {
                answer.append(tmp)
                return
            }
            // 退出条件
            if index == n + 1 {
                return;
            }
            // 当前位置
            tmp.append(index)
            dfs(index: index + 1)
            // 移除当前位置
            tmp.removeLast()
            dfs(index: index + 1)
        }
        
        dfs(index: 1)
        return answer
    }
    
    func creashTest() {
        let item1_1 = YDDHomeToolbarItem()
        let item1_2 = YDDHomeToolbarItem()
        let item1_3 = YDDHomeToolbarItem()
        
        let cateory1 = YDDHomeCategoryItem()
        cateory1.category = "category1"
        cateory1.icons.append(item1_1)
        cateory1.icons.append(item1_2)
        cateory1.icons.append(item1_3)
        
        let item_2_1 = YDDHomeToolbarItem()
        let item_2_2 = YDDHomeToolbarItem()
        let item_2_3 = YDDHomeToolbarItem()
        
        let cateory2 = YDDHomeCategoryItem()
        cateory2.category = "category2"
        cateory2.icons.append(item_2_1)
        cateory2.icons.append(item_2_2)
        cateory2.icons.append(item_2_3)
        
        let data = YDDHomeAllToolbarData()
        data.iconCategories = [cateory1, cateory2]
        
        var iconsMap: [Int: YDDHomeToolbarItem] = [:]
        //
        iconsMap = Dictionary(uniqueKeysWithValues: data.iconCategories.flatMap { $0.icons.map { (($0.id ?? -1), $0) } })
        print("test->\(iconsMap)")
    }
    
    var lock = NSLock()
    var isRemoteconfigFetched = false
    
    func lockTest() {
        for _ in 0...4 {
            Task {
                await _lockTest()
            }
        }
    }
    
    func _lockTest() async {
        print("1717487799 1: \(Thread.current)")
        return await withCheckedContinuation { continuation in
            print("1717487799 2: \(Thread.current)")
//            DispatchQueue.global().async {
                print("1717487799 3: \(Thread.current)")
                print("1717487799 锁前")
                self.lock.lock()
                print("1717487799 已锁")
                guard !self.isRemoteconfigFetched else {
                    print("1717487799 解锁1")
                    self.lock.unlock()
                    DispatchQueue.main.async {
                        continuation.resume()
                    }
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isRemoteconfigFetched = true
                    self.lock.unlock()
                    continuation.resume()
                }
//            }
        }
        
    }
}

public class YDDHomeAllToolbarData: NSObject {
    @objc public var iconCategories: [YDDHomeCategoryItem] = []
}

public class YDDHomeCategoryItem: NSObject {
    @objc public var category: String = ""
    @objc public var icons: [YDDHomeToolbarItem] = [YDDHomeToolbarItem]()
    public override init() {
        super.init()
    }
}

public class YDDHomeToolbarItem: NSObject {
    public var id: Int?

    init(id: Int? = nil) {
        self.id = id
    }
}
