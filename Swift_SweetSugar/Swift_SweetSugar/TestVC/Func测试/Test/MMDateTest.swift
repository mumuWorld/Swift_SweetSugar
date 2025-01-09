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
//        createType()
        createType_2()
//        hourTest()
//        formatTest()
    }
    
    class func formatTest() {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        formatter.locale = NSLocale.system
        formatter.calendar = Calendar(identifier: .gregorian)
        //用此formatter 1970-01-01 21:20:00 时间会有问题。
        let formatterStr = "yyyy-MM-dd hh:mm:ss"
        let formatterStr_2 = "yyyy-MM-dd HH:mm:ss"

        let timeStr = "1970-01-01 20:20:00"
        formatter.dateFormat = formatterStr
        let date = formatter.date(from: timeStr)
        //"test->day: 1 hour: 20 minute: 20 isLeapMonth: false "
        let components = formatter.calendar.dateComponents([.day,.hour,.minute], from: date ?? Date())
        debugPrint("test->\(components)")
        
        let formatter_2 = DateFormatter()
        formatter_2.calendar = Calendar(identifier: .gregorian)
        //此格式 只能正确返回24小时制时间。
        formatter_2.dateFormat = formatterStr_2
        let date_2 = formatter_2.date(from: timeStr)

        mm_printLog("date-\(date)")
        debugPrint("debug_test")
        print("test_print")

        // 此格式不准确
        let formatter_new = DateFormatter()
        formatter_new.locale = Locale(identifier: "en_US_POSIX")
        formatter_new.dateFormat = formatterStr_2
        let date_new = formatter_new.date(from: timeStr)
        // date3-Optional(1970-01-01 12:20:00 +0000)
        mm_printLog("date3-\(date_new)")
        
        let formatter_new_2 = DateFormatter()
        formatter_new_2.locale = Locale(identifier: "en_US_POSIX")
        formatter_new_2.dateFormat = formatterStr
        let date_new_2 = formatter_new_2.date(from: timeStr)
        // date4-nil
        mm_printLog("date4-\(date_new_2)")
        
        // 2023-07-12 13:31:27 将此北京时间转换为 12小时格式的 dateString 用上面的formatter没问题。 H大写
//        (lldb) po formatter_new.string(from: Date().addingTimeInterval(7200))
//        "2023-07-12 13:31:27"
//        (lldb) po formatter_new_2.string(from: Date().addingTimeInterval(7200))
//        "2023-07-12 01:31:50"
        
        mm_printLog("date -- end")

        /*12小时制
         timeStr = "1970-01-01 9:20:00"
         date = "some : 1970-01-01 1:20:00 AM +0000"
         data_2 = nil
         
         timeStr = "1970-01-01 20:20:00"
         date = nil
         data_2 = nil
         
         24小时制
         timeStr = "1970-01-01 9:20:00"
         date = "1970-01-01 01:20:00 +0000"
         data_2 = "1970-01-01 01:20:00 +0000"
         
         timeStr = "1970-01-01 20:20:00"
         date = nil
         data_2 = 1970-01-01 12:20:00 +0000
         */
    }
    
    class func hourTest() {
        //24点的写法是错的。所以没有24点
        let date = Date.getDate(dateStr: "2022-01-02 00:00", format: kDateFormatterKey.ShortYMDHM)
        var com = Date.mCalendar.dateComponents([.hour, .day], from: date)
        //如果没值就2小时刷一次
        var hour = com.hour ?? 22
        //获得明天
        let tommorrow = Calendar.current.date(byAdding: .hour, value: 24 - hour, to: date) ?? Date()
        
        com = Date.mCalendar.dateComponents([.hour, .day], from: tommorrow)

        let day = com.day
        hour = com.hour ?? 0
        mm_printLog("test->\(hour), day-\(day)")
    }
    
    class func createType_2() {
//        493708.3429942501
        let media = CACurrentMediaTime()
        //682402463.341505,  从 Jan 1 2001 00:00:00 GMT.
        let abso = CFAbsoluteTimeGetCurrent()
        //1733127777.932874
        let date = Date().timeIntervalSince1970
        // me->365395.3615600001, abs->754820577.932873, date->1733127777.932874\
        mm_printsLog("me->\(media), abs->\(abso), date->\(date)")
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
                m[i] = CFAbsoluteTimeGetCurrent()
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
        let date = Date.getDate(dateStr: "2022-11-1", format: .ShortYMD)
//        "20220324"
        let dateStr = Date.dateStr(timeStamp: Int(date.timeIntervalSince1970), formatter: .chineseMDHM)
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
