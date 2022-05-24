//
//  MMDateTest.swift
//  Swift_SweetSugar
//
//  Created by Mumu on 2022/1/22.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class MMDateTest {
    class func dateTest() {
//        Date.getCurWeeks()
//        test2()
//        create()
        createType()
    }
    
    class func createType() {
        //结束耗时 -> 0.00531"
        CreateTool.timeRecord(title: "CACurrentMediaTime") {
            var m: [Int: CFTimeInterval] = [:]
            for i in 0...100000 {
                m[i] = CACurrentMediaTime()
            }
            mm_printLog("test->\(m.count)")
        }
        CreateTool.timeRecord(title: "Date") {
            var m: [Int: Date] = [:]
            for i in 0...100000 {
                m[i] = Date()
            }
            mm_printLog("test->\(m.count)")
        }
        CreateTool.timeRecord(title: "CFAbsoluteTime") {
            var m: [Int: CFTimeInterval] = [:]
            for i in 0...100000 {
                m[i] = CFAbsoluteTime()
            }
            mm_printLog("test->\(m.count)")
        }
        /*
         CACurrentMediaTime-计时开始 ->"
         🔨[CreateTool timeRecord(title:call:)](28): 结束耗时 -> 0.05645"
         "🔨[CreateTool timeRecord(title:call:)](25): Date-计时开始 ->"
         "🔨[MMDateTest createType()](33): test->100001"
         "🔨[CreateTool timeRecord(title:call:)](28): 结束耗时 -> 0.05237"
         "🔨[CreateTool timeRecord(title:call:)](25): CFAbsoluteTime-计时开始 ->"
         "🔨[MMDateTest createType()](40): test->100001"
         "🔨[CreateTool timeRecord(title:call:)](28): 结束耗时 -> 0.05034"
         */
    }
    
    class func create() {
        let date = Date()
        //获取周一00 -> 下周一的0点
        let dataComponents = Date.mCalendar.dateComponents([.weekday, .year, .day, .month], from: date)
        var weekday = (dataComponents.weekday ?? 1) - 2
        if weekday == -1 { //周日
            weekday = 6
        }
        let todayZero = Date.getDate(dateStr: String(format: "%d-%d-%d", dataComponents.yd_year, dataComponents.yd_month, dataComponents.yd_day), format: .ShortYMD)
        let dayDistance: TimeInterval = 24 * 60 * 60
        let leftDistance = (Double(weekday) + 7) * dayDistance
        let rightDistance = Double(weekday) * dayDistance
        let minDate = Date(timeInterval: -leftDistance, since: todayZero).timeIntervalSince1970
        let maxDate = Date(timeInterval: -rightDistance, since: todayZero).timeIntervalSince1970
        
        mm_printLog(maxDate)
        
    }
    
    class func test2() {
//        let date = Date() "2022-01-23 00:00:00"
        let date = Date.getDate(dateStr: "2022-1-1", format: .ShortYMD)
//        "20220324"
        let dateStr = Date.dateStr(timeStamp: Int(Date().timeIntervalSince1970), formatter: .yyyyMMdd)
               let component = Date.mCalendar.dateComponents([.weekday , .weekdayOrdinal , .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .month], from: date)
               //2022.01.22 星期六
               let val_w = component.weekday // 7
               let val_1 = component.weekdayOrdinal // 4
               let val_2 = component.quarter // 0
               
               
               let month = DateFormatter().monthSymbols[(component.month ?? 1) - 1].substring(to: 3)
               /*
                po component.weekOfMonth
               ▿ Optional<Int>
                 - some : 4
                component.weekOfYear
                ▿ Optional<Int>
                  - some : 4
                po component.yearForWeekOfYear
                  - Int : 2022
                */
               mm_printLog("")
    }
    
    func sum() {
        var sum:Int = 0
        sum += 12
        sum += 111
        sum += 190
        sum += 63
        
    }
}
