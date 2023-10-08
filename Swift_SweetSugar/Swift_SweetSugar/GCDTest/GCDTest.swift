//
//  GCDTest.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/11/25.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation
import os

class GCDTest {
    func test1() -> Void {
        let ser = DispatchQueue(label: "serial")
        let con = DispatchQueue(label: "con", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
//        ser.async {
//            mm_printLog("1")
            DispatchQueue.global().async {
                mm_printLog("2")
                DispatchQueue.main.async {
                    mm_printLog("3")
                }
                DispatchQueue.main.sync {
                    mm_printLog("4")
                }
                mm_printLog("5")
            }
        }
//    }
    
    func test2() {
        let ser = DispatchQueue(label: "serial")
        let con = DispatchQueue(label: "con", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        ser.async {
            mm_printLog("1, \(Thread.current)")
            con.sync {
                mm_printLog("2, \(Thread.current)")
            }
        }
        sleep(1)
        ser.async {
            mm_printLog("3, \(Thread.current)")
            DispatchQueue.global().sync {
                mm_printLog("4, \(Thread.current)")
            }
        }
    }
    
    /// 并发队列测试
    func test3() {
        let iterations = 5
        let queue = DispatchQueue(label: "com.example.myConcurrentQueue", attributes: .concurrent)
        // 并发迭代
        DispatchQueue.concurrentPerform(iterations: iterations) { i in
            print("Task \(i) started")
            // Perform some work here
            print("Task \(i) completed")
        }
        print("------end")
        queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations) { i in
                print("Task \(i) started")
                // Perform some work here
                print("Task \(i) completed")
            }
        }
    }
    
    func AllTestEntry() {
        if #available(iOS 16.0, *) {
            test4()
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// 线程安全测试
    @available(iOS 16.0, *)
    func test4() {
        let store = Store<State, Void>(state: .init()) { state, _ in
            var state = state
            state.value += 1
            return state
        }
        
        DispatchQueue.concurrentPerform(iterations: 1_000_000) { _ in
            store.send(())
//            mm_printLog("test->111")
        }
        
        mm_printLog("test->\(store.value) == 1_000_000")
    }
}


//MARK: - OSAllocatedUnfairLock 和  NSRecursiveLock 的使用

struct State {
    var value = 0
}

@available(iOS 16.0, *)
@dynamicMemberLookup final class Store<State, Action> {
    typealias Reduce = (State, Action) -> State
    
    private var state: OSAllocatedUnfairLock<State>
    private let reduce: Reduce
    
    init(state: State, reduce: @escaping Reduce) {
        self.state = .init(initialState: state)
        self.reduce = reduce
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
        state.withLock { $0[keyPath: keyPath] }
    }
    
    func send(_ action: Action) {
        state.withLock { state in
            state = reduce(state, action)
        }
    }
}

@dynamicMemberLookup final class Store_2<State, Action> {
    typealias Reduce = (State, Action) -> State
    
    private var state: State
    private let reduce: Reduce
    
    private let lock = NSRecursiveLock()
    
    init(state: State, reduce: @escaping Reduce) {
        self.state = state
        self.reduce = reduce
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
        lock.withLock {
            state[keyPath: keyPath]
        }
    }
    
    func send(_ action: Action) {
        lock.withLock {
            state = reduce(state, action)
        }
    }
}
