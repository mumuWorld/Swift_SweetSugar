//
//  MMCombineTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/8/9.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation

class MMCombineTest {
    static var share: MMCombineTest = MMCombineTest()
    private init() {}
    
    public func start() {
        Task.detached {
            // 在异步任务中执行异步操作
            try? await self._start()
        }
    }
    
    private func _start() async -> Bool {
        let caid: String = await _fetchCaid()
        print("test->打印: \(caid)")
        return true
    }
    
    private func _fetchCaid() async -> String {
        let value = await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3){
                continuation.resume(returning: "测试文本")
            }
            continuation.resume(returning: "测试11")
        }
        return value
    }
}
