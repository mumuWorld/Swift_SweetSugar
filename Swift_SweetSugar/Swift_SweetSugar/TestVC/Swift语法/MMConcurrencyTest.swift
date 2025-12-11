//
//  MMConcurrencyTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/10/17.
//  Copyright © 2025 Mumu. All rights reserved.
//

import Foundation

struct TaskGroupSampleTest {
    func start() async {
        print("Start")
        // 1
        await withTaskGroup(of: Int.self) { group in
            var curValue = 0
            print("before Task added")
            for i in 0 ..< 3 {
                // 2
                group.addTask {
                    await work(i)
                }
            }
            print("Task added")
            // 4  可省略 ，编译器会自动生成。
            for await result in group {
                print("Get result: \(result)")
                curValue += result
                print("test->curValue: \(curValue)")
            }
            // 5
            print("Task ended")
            // 6 如果没有 4 编译器会自动添加此行
//            group.waitForAll()
        }
        print("End")
    }
    private func work(_ value: Int) async -> Int {
        print("Start work \(value)")
        if #available(iOS 16.0, *) {
            try? await Task.sleep(for: .seconds(Double(value)))
        } else {
            // Fallback on earlier versions
        }
        print("Work \(value) done")
        return value
    }
    /*
     在使用 withTaskGroup 时，如果不需要处理错误，子任务应该捕获并处理所有可能的错误。如
     果需要错误传播，应该使用 withThrowingTaskGroup。当任务组中的某个子任务抛出错误时：
     1. 该错误会立即传播到任务组的调用者
     2. 任务组会自动取消所有其他正在运行的子任务
     3. 任务组会等待所有子任务完成（包括被取消的任务）后才真正结束
     */
    func startError() async {
        do {
            try await withThrowingTaskGroup(of: Int.self) { group in
                group.addTask {
                    try await riskyWork(0)
                }
                group.addTask {
                    try await riskyWork(1)
                }
                // 如果任⼀⼦任务抛出错误，会直接被外层 catch
                for try await result in group {
                    print("Result: \(result)")
                }
            }
        } catch {
            print("Task group failed: \(error)")
        }
    }
    
    private func riskyWork(_ value: Int) async throws -> Int {
        if value == 0 {
            return value
        } else {
            throw NSError(domain: "com.mumu.error", code: 1, userInfo: nil)
        }
    }
}

extension TaskGroupSampleTest {
    /// 使用异步绑定的方式 结构化并发
    func start2() async {
        print("Start")
        async let v0 = work(0)
        async let v1 = work(1)
        async let v2 = work(2)
        print("Task added")
        let result = await v0 + v1 + v2
        print("Task ended")
        print("End. Result: \(result)")
    }
}
