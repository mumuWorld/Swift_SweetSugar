//
//  MMDispatchTimer.swift
//  定时器组件
//
//  Created by yangjie on 2019/8/12.
//  Copyright © 2019 YangJie. All rights reserved.
//

import Foundation
import Dispatch

class MMDispatchTimer {
    static let shareInstance: MMDispatchTimer = MMDispatchTimer()
    
    private var cacheTimer: [String: DispatchSourceTimer] = Dictionary()
    
    var mutex_lock: pthread_mutex_t = pthread_mutex_t()
    
    var attr: pthread_mutexattr_t = pthread_mutexattr_t()
    
    init() {
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL)
        pthread_mutex_init(&mutex_lock, &attr)
    }
    
    deinit {
        pthread_mutexattr_destroy(&attr)
        pthread_mutex_destroy(&mutex_lock)
    }
    
    
    /// 只有一次的block
    /// - Parameters:
    ///   - afterTime: 多少时间后执行
    ///   - async: 是否异步 default:false
    ///   - task: 任务
    /// - Returns: timerkey
    @discardableResult
    class func createOnceTimer(afterTime: TimeInterval, async: Bool = false, task: (() -> (Void))?) -> String? {
        return createTimer(startTime: afterTime, infiniteInterval: 0, isRepeat: false, async: async, task: task)
    }
    
    /// block定时器
    ///
    /// - Parameters:
    ///   - startTime: 开始时间 Double  eg: 0.1
    ///   - infiniteInterval: 重复时间  eg: 0.1
    ///   - isRepeat: 是否重复
    ///   - async: 是否同步
    ///   - task: 回调block
    /// - Returns: timer实例对应的 字符串
    @discardableResult
    class func createTimer(startTime: TimeInterval, infiniteInterval: TimeInterval, isRepeat: Bool, async: Bool, task: (() -> (Void))?) -> String? {
        guard let tTask = task, startTime >= 0 else { return nil }
        if (infiniteInterval < 0 && isRepeat) { return nil }
        let queue = async ? DispatchQueue.global() : DispatchQueue.main
        
        let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [DispatchSource.TimerFlags.init(rawValue: 0)], queue: queue)
        pthread_mutex_lock(&shareInstance.mutex_lock)
        let timerName = String(format: "timers_%p", timer as! CVarArg)
        shareInstance.cacheTimer[timerName] = timer
        pthread_mutex_unlock(&shareInstance.mutex_lock)
        timer.schedule(deadline: DispatchTime.secondTime(value: startTime), repeating: infiniteInterval, leeway: .milliseconds(10))
        timer.setEventHandler(handler: {
            tTask()
            if !isRepeat {
                MMDispatchTimer.cancelTimer(timerName: timerName)
            }
        })
        timer.resume()
        return timerName
    }
    
    class func createTimer(startTime: TimeInterval, infiniteInterval: TimeInterval, isRepeat: Bool, async: Bool,  target: Any?, selector: Selector?) -> String? {
        guard let tTask = selector,let mTarget = target else {
            return nil
        }
        let objc: NSObject = mTarget as! NSObject
        let timerName = self.createTimer(startTime: startTime, infiniteInterval: infiniteInterval, isRepeat: isRepeat, async: async) { () -> (Void) in
            if objc.responds(to: tTask) {
                objc.perform(tTask)
            }
        }
        return timerName
    }
    
    class func cancelTimer(timerName: String?) -> Void {
        guard let timerN = timerName else { return }
        guard let timer: DispatchSourceTimer = shareInstance.cacheTimer[timerN] else { return }
        timer.cancel()
        pthread_mutex_lock(&shareInstance.mutex_lock)
        shareInstance.cacheTimer.removeValue(forKey: timerN)
        pthread_mutex_unlock(&shareInstance.mutex_lock)
    }
}
