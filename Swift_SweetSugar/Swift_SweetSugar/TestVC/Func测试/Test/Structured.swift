//
//  Structured.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/12/28.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import Kingfisher

struct TaskGroupSample {
    @available(iOS 15.0.0, *)
    private func work(_ value: Int) async -> Int {
      // 3
      print("Start work \(value)")
    await Task.sleep(UInt64(value) * NSEC_PER_SEC)
      print("Work \(value) done")
      return value
    }
    
    @available(iOS 15.0.0, *)
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
    
    @available(iOS 15.0.0, *)
    func start3() async {
      async let v0 = work(0)

      print("End")

      // 下面是编译器自动生成的伪代码
      // 注意和 Task group 的不同
      
      // v0 绑定的任务被取消
      // 伪代码，实际上绑定中并没有 `task` 这个属性
//      v0.task.cancel()
      // 隐式 await，满足结构化并发   _ = await v0
    }

    @available(iOS 15.0.0, *)
    func start4() async {
        let outer = Task {
          let innner = Task {
            await work(1)
          }
          await work(2)
        }

        outer.cancel()
        mm_printLog(outer.isCancelled)
//        outer.isCancelled // true
//        inner.isCancelled // false
    }
    
    @available(iOS 15.0.0, *)
    func start5() async {
      async let t1 = Task {
        await work(1)
          //false
        print("Cancelled: \(Task.isCancelled)")
      }.value
            
      async let t2 = Task.detached {
        await work(2)
          //false
        print("Cancelled: \(Task.isCancelled)")
      }.value
    }

    @available(iOS 15.0.0, *)
    func start6(v: Int) async {
        await Task.sleep(1000000)
        mm_printLog("执行6->\(v),\(Thread.current)")
    }
    
    @available(iOS 15.0.0, *)
    func start7() async {
        await Task.sleep(UInt64(500000))
        mm_printLog("执行7->\(Thread.current)")
    }
}

@available(iOS 15.0.0, *)
actor Holder {
    var results: [String] = []
      func setResults(_ results: [String]) {
        self.results = results
      }
        
      func append(_ value: String) {
        results.append(value)
      }
}

class TaskGroupSampleTool {
    @available(iOS 15.0.0, *)
    func test() {
        let holder = Holder()

        Task {
            await TaskGroupSample().start4()
            
            await holder.setResults(["test"])
            await holder.append("new")
            
            let res = await holder.results
            mm_printLog(res)
        }
        
        
    }
    
    /*
        1 等同于放在一个task中，顺序执行。
      2 完成的时候是和最后一个await的完成时的线程一致。
     */
    @available(iOS 15.0.0, *)
    func test2() {
        mm_printLog("执行->start")
        Task {
            mm_printLog("执行t1->\(Thread.current)")
            await TaskGroupSample().start6(v: 1)
            mm_printLog("执行t1E->\(Thread.current)")
        }
        
        Task {
            mm_printLog("执行t2->\(Thread.current)")
            await TaskGroupSample().start6(v: 3)
            mm_printLog("执行t2e->\(Thread.current)")
        }
        
        Task {
            mm_printLog("执行t3->\(Thread.current)")
            await TaskGroupSample().start6(v: 2)
            mm_printLog("执行t3e1->\(Thread.current)")
            await TaskGroupSample().start7()
            mm_printLog("执行t3e2->\(Thread.current)")
            await TaskGroupSample().start7()
            mm_printLog("执行t3ee->\(Thread.current)")
        }
        
        Task.detached(priority: .none) {
            mm_printLog("执行t4->\(Thread.current)")
            await TaskGroupSample().start6(v: 4)
            mm_printLog("执行t4e1->\(Thread.current)")
            await TaskGroupSample().start7()
            mm_printLog("执行t4ee->\(Thread.current)")
        }
        mm_printLog("执行->end")
    }
    
    func shouldLoopAgain() -> Bool {
        return true
    }

    @available(iOS 15.0.0, *)
    func test_3() {
        //必须对self进行解包 否则不持有self
        Task.detached { [weak self] in
            guard let self = self else { return }
            print("Task 1")
            var loop = true
            while loop {
                loop = self.shouldLoopAgain()
                //让出线程
//                if loop {
//                    await Task.yield()
//                }
            }
            print("All Done")
        }
        //有概率，不会执行
        Task.detached {
            print("Task 2")
        }
        print("Task init")
    }
    
    @available(iOS 15.0.0, *)
    func test_4() {
        Task {
            let res = await callBack_2(type: 0)
            do {
                let res_2 = try await callBack(type: 1)
                mm_printLog(res_2)
            } catch let e {
                mm_printLog(e)
            }
            mm_printLog(res)
        }
    }
    
    @available(iOS 15.0.0, *)
    func callBack(type: Int) async throws -> Int {
        return try await withCheckedThrowingContinuation({ cc in
            if type == 0 {
                cc.resume(with: Result.success(type))
            } else {
                cc.resume(throwing: NSError(domain: "com.mumu", code: -1, userInfo: nil))
            }
        })
    }
    
    @available(iOS 15.0.0, *)
    func callBack_2(type: Int) async -> Int {
        await withCheckedContinuation { cc in
//            let error = NSError(domain: "com.mumu", code: -2, userInfo: nil)
//            cc.resume(with: Result.failure(error))
            cc.resume(with: Result.success(type))
        }
    }
    
    @available(iOS 15.0.0, *)
    func test_6() {
        var name = "hello"
        Task { [name] in
            let validName = "onevcat" == name
        }
        let name_2 = "hello"
        Task {
            let validName = "onevcat" == name_2
            
        }
        let simple = TaskGroupSample()
        Task {
            let validName = simple
            mm_printLog(validName)
        }
        
        let view = UIView()
        Task {
            let validName = view
            mm_printLog(validName)
        }
    }
}
