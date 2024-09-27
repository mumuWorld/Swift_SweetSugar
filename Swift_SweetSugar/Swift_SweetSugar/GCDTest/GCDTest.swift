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
        mm_printLog("1")
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
        mm_printLog("6")

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
    
    func test_sync() {
        let queue = DispatchQueue(label: "com.example.myQueue")
        queue.sync {
            print("test->sdfdf")
        }
    }
    
    
    func AllTestEntry() {
        if #available(iOS 16.0, *) {
            testGCDDownload()
//            testOperationDownload()
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
    
    /// 返回值测试
    func test5() {
        let queue = DispatchQueue(label: "com.serial.queue")
        // 会接受block内的返回值
        let reuslt = queue.sync {
            return doSomething(v: "q")
        }
    }
    
    func doSomething(v: String) -> String {
        print("test->doSomething: \(v)")
        return "doSomething" + v
    }
    
    /// gcd限制下载
    func testGCDDownload() {
        let downloader = ImageDownloader()
        downloader.downloadImages()

    }
    /// operationQueue下载
    func testOperationDownload() {
        let downloader = ImageDownloader()
        downloader.downloadImages_OperationQueue {
            mm_printLog("下载完成")
        }
    }
}

class ImageDownloader {
    
    /// 功能正常
    func downloadImages() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "imageDownloadQueue", qos: .utility, attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 5) // Limiting concurrency to 5
        
        // Download each image concurrently with limited concurrency
        for imageUrl in 0...100 {
            print("test-> 异步调用： \(imageUrl)")
            group.enter()
            queue.async {
                semaphore.wait() // Wait for a semaphore signal
                defer {
                    semaphore.signal() // Release the semaphore
                    group.leave()
                }
                print("Downloaded image size: \(imageUrl)")
                Thread.sleep(forTimeInterval: 1)
                //                }
            }
        }
        
        print("test-> 调用这里")
        // Notify the main thread when all downloads are complete
        group.notify(queue: DispatchQueue.main) {
            print("All images downloaded!")
            // Perform any actions you want after all images are downloaded
        }
        print("test-> 调用这里2")
    }
    
    /// 也可以完成下载。 调用顺序 调用到这里1 -> 调用到这里2 -> 1...100 ->  All images downloaded!
    func downloadImages_OperationQueue(completeion: (() -> Void)? = nil) {
        let operationCount = 100
        
        let operationQueue = OperationQueue()
        operationQueue.name = "imageDownloadQueue"
        operationQueue.maxConcurrentOperationCount = 5 // Limiting concurrency to 5
        operationQueue.progress.totalUnitCount = Int64(operationCount)
        
        // Download each image concurrently with limited concurrency
        for imageUrl in 0..<operationCount {
            print("添加到队列: \(imageUrl)")
            // Create a custom operation for downloading the image
            let downloadOperation = BlockOperation {
                print("Downloaded image size: \(imageUrl), progress: \(operationQueue.progress.completedUnitCount)")
                Thread.sleep(forTimeInterval: 1)
            }
            // Add the operation to the queue
            operationQueue.addOperation(downloadOperation)
        }
        
        print("调用到这里")
        // Add a completion block to the operation queue
        operationQueue.addOperation {
            print("All images downloaded!")
            completeion?()
            // Perform any actions you want after all images are downloaded
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            // 只会暂停进度条报告。不会暂停进度
//            operationQueue.progress.pause()
        }
        print("调用到这里2")
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
