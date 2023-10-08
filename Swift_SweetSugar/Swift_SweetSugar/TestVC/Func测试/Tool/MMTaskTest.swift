//
//  MMTaskTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/7/25.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

class MMTaskTest {
    
    static let shared: MMTaskTest = MMTaskTest()
    
    var _workItem: DispatchWorkItem?
    
    var _timer: DispatchSourceTimer?
    
    func test() {
        workItemCancelTest()
    }
    
    func workItemCancelTest() {
        let item = DispatchWorkItem { [weak self] in
            print("test->事务: start")
            self?.startTimer()
        }
        _workItem = item
//        DispatchQueue.main.async(execute: item)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self._workItem?.cancel()
//            print("test->事务: 取消")
//        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6, execute: item)
    }
    
    func startTimer() {
        var count = 0
        let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [DispatchSource.TimerFlags.init(rawValue: 0)], queue: DispatchQueue.main)
        timer.schedule(deadline: DispatchTime.now(), repeating: .seconds(1), leeway: .milliseconds(10))
        timer.setEventHandler(handler: { [weak self] in
            print("test->事务: \(count)")
            count += 1
        })
        timer.resume()
        _timer = timer
    }
}
