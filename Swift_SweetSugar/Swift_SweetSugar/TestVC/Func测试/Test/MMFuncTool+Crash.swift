//
//  MMFuncTool+Crash.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/1/6.
//  Copyright © 2025 Mumu. All rights reserved.
//

import Foundation

let solution: Solution2 = Solution2()

func crash_test41_2() {
    solution.lockTest()
}


extension MMFuncTool {
    // 模拟线程安全问题: 并没有复现EXC_BAD_ACCESS : 实际出现吃错误是  NSTaggedPointerString objectForKey:
    func crash_threadSafe() {
        
        // 子线程访问数据
        DispatchQueue.global().async {
            for i in 0..<1000 {
                if let v = Singleton.shared.getData(key: "key\(i)") {
                    print("子线程读取数据: \(v)")
                } else {
                    mm_printLog("子线程没有读取到 key： \(i)")
                }
            }
        }
        
        // 主线程更新数据
        DispatchQueue.main.async {
            for i in 0..<1000 {
                Singleton.shared.updateData(key: "key\(i)", value: "value\(i)")
                if i % 10 == 0 {
                    print("主线程更新数据: \(i)")
                }
            }
        }
    }
}

// 单例类
class Singleton {
    static let shared = Singleton()
    
    var data: [String: String] = [:]
    
    private init() {}
    
    // 模拟线程安全问题
    func getData(key: String) -> String? {
        return data[key]
    }
    
    func updateData(key: String, value: String) {
        data[key] = value
    }
}

