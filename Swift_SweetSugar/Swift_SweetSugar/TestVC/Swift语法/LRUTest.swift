//
//  LRUTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/2/23.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation

class LRUCache<Key: Hashable, Value> {
    private var cacheDict = [Key: LinkedListNode]()
    private let capacity: Int
    private let linkedList = DoublyLinkedList()

    init(capacity: Int) {
        self.capacity = max(0, capacity)
    }

    func getValue(forKey key: Key) -> Value? {
        if let node = cacheDict[key] {
            // 移动节点到链表头部表示最近使用
            linkedList.moveToHead(node)
            return node.value
        }
        return nil
    }

    func setValue(_ value: Value, forKey key: Key) {
        if let node = cacheDict[key] {
            // 如果键已存在，更新值并移动到链表头部
            node.value = value
            linkedList.moveToHead(node)
        } else {
            // 如果缓存已满，删除最久未使用的节点
            if cacheDict.count >= capacity, let tail = linkedList.removeTail() {
                cacheDict.removeValue(forKey: tail.key)
            }

            // 创建新节点并插入到链表头部
            let newNode = LinkedListNode(key: key, value: value)
            linkedList.addToHead(newNode)
            cacheDict[key] = newNode
        }
    }

    private class LinkedListNode {
        var key: Key
        var value: Value
        var next: LinkedListNode?
        weak var prev: LinkedListNode?

        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }

    private class DoublyLinkedList {
        private var head: LinkedListNode?
        private var tail: LinkedListNode?

        func addToHead(_ node: LinkedListNode) {
            node.next = head
            node.prev = nil

            if head == nil {
                tail = node
            } else {
                head?.prev = node
            }

            head = node
        }

        func moveToHead(_ node: LinkedListNode) {
            if node !== head {
                let prev = node.prev
                let next = node.next

                prev?.next = next
                next?.prev = prev

                node.next = head
                node.prev = nil

                if node === tail {
                    tail = prev
                }

                head?.prev = node
                head = node
            }
        }

        func removeTail() -> LinkedListNode? {
            let currentTail = tail

            if tail === head {
                tail = nil
                head = nil
            } else {
                tail = tail?.prev
                tail?.next = nil
            }

            return currentTail
        }
    }
}


class LRUCacheTest {
    class Node {
        var key: Int
        var value: Int
        var prev: Node?
        var next: Node?
        
        init(key: Int, value: Int) {
            self.key = key
            self.value = value
        }
    }
    
    var capacity: Int
    var cache: [Int: Node]
    var head: Node
    var tail: Node
    
    init(_ capacity: Int) {
        self.capacity = capacity
        self.cache = [Int: Node]()
        self.head = Node(key: 0, value: 0)
        self.tail = Node(key: 0, value: 0)
        self.head.next = self.tail
        self.tail.prev = self.head
    }
    
    func get(_ key: Int) -> Int {
        guard let node = cache[key] else { return -1 }
        moveToHead(node)
        return node.value
    }
    
    func put(_ key: Int, _ value: Int) {
        if let node = cache[key] {
            node.value = value
            moveToHead(node)
        } else {
            let newNode = Node(key: key, value: value)
            cache[key] = newNode
            addToHead(newNode)
            if cache.count > capacity {
                removeTail()
            }
        }
    }
    
    private func addToHead(_ node: Node) {
        node.prev = head
        node.next = head.next
        head.next?.prev = node
        head.next = node
    }
    
    private func removeNode(_ node: Node) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
    }
    
    private func moveToHead(_ node: Node) {
        removeNode(node)
        addToHead(node)
    }
    
    private func removeTail() {
        guard let tailNode = tail.prev else { return }
        removeNode(tailNode)
        cache.removeValue(forKey: tailNode.key)
    }
}
