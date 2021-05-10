//
//  CreateTool.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/9/27.
//  Copyright © 2019 Mumu. All rights reserved.
//

import UIKit

class CreateTool {
    class func createIntArray(count: Int,minP: Int,maxP: Int) -> Array<Int> {
        var randomArr: [Int] = Array()
        for _ in 0..<count {
            let random: Int = Int(arc4random_uniform(UInt32(maxP)))
            let fit = random < minP ? random + minP : random            
            randomArr.append(fit)
        }
        return randomArr
    }
    
    class func timeRecord(title: String, call: () -> ()) -> Void {
//        CFAbsoluteTimeGetCurrent()
        let startTime = CACurrentMediaTime()
        mm_printLog("\(title)-计时开始 ->")
        call()
        let endTime = CACurrentMediaTime()
        mm_printLog("结束耗时 -> \(String(format: "%0.5f", (endTime - startTime)))")
    }
}
