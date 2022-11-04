//
//  Date+MM_Extension.swift
//  MMQRCode
//
//  Created by yangjie on 2019/8/6.
//  Copyright © 2019 yangjie. All rights reserved.
//

import Foundation

enum kDateFormatterKey: String {
    case Default = "yyyy-MM-dd HH:mm:ss"
    case ShortYMD = "yyyy-MM-dd"
    case ShortYMDHM = "yyyy-MM-dd HH:mm"
    case ShortMD = "MM-dd"
    case chineseMDHM = "M月dd日 HH:mm"
    case yyyyMMdd
}

extension Date {
    static let shareFormatter: DateFormatter = {
        let item = DateFormatter()
        item.locale = Locale.current
        item.timeZone = TimeZone.current
        return item
    }()
    
    static let mCalendar: Calendar = {
        var item = Calendar(identifier: .gregorian)
        item.locale = Locale.current
        item.timeZone = TimeZone.current
        return item
    }()

    static func currentTimeStamp() -> Int {
        let time = Date().timeIntervalSince1970
        return Int(time)
    }
    
    static func getDate(dateStr: String, format: kDateFormatterKey = kDateFormatterKey.Default) -> Date {
        shareFormatter.dateFormat = format.rawValue
        guard let date = shareFormatter.date(from: dateStr) else {
            return Date()
        }
        return date
    }
    
    static func currentDateStr(formatter: kDateFormatterKey = kDateFormatterKey.Default) -> String {
            let date = Date()
            shareFormatter.locale = Locale.current
            shareFormatter.timeZone = TimeZone.current
            shareFormatter.dateFormat = formatter.rawValue
            let result = shareFormatter.string(from: date)
            return result
    }
    /// 根据时间戳 int 返回 格式日期字符串
    ///
    /// - Parameters:
    ///   - timeStamp: Int
    ///   - formatter: 格式
    /// - Returns: 日期
    static func dateStr(timeStamp: Int, formatter: kDateFormatterKey = kDateFormatterKey.Default) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        shareFormatter.locale = Locale.current
        shareFormatter.timeZone = TimeZone.current
        shareFormatter.dateFormat = formatter.rawValue
        let result = shareFormatter.string(from: date)
        return result
    }
    
    static func getDayMonthYear(dateStr: String, formate: kDateFormatterKey = .Default) -> (day: Int, month: Int, year: Int) {
        shareFormatter.dateFormat = formate.rawValue
        guard let date = shareFormatter.date(from: dateStr) else {
            return (0,0,0)
        }
        return getDMY(with: date)
    }
    
    static func getDMY(with date: Date) -> (day: Int, month: Int, year: Int) {
        let dataComponents = mCalendar.dateComponents([.day , .month , .year], from: date)
        let day = dataComponents.day
        let month = dataComponents.month
        let year = dataComponents.year
        return (day ?? 0, month ?? 0, year ?? 0)
    }
    
    static func getComponent(dateStr: String, formate: kDateFormatterKey = .Default, components: Set<Calendar.Component>) -> DateComponents {
        shareFormatter.dateFormat = formate.rawValue
        guard let date = shareFormatter.date(from: dateStr) else {
            return DateComponents()
        }
        let dataComponents = mCalendar.dateComponents(components, from: date)
        return dataComponents
    }
    
    static func getCurWeeksComponents() {
        //判断当前weekday 是多少， 前后
        let date = Date()
        let dataComponents = mCalendar.dateComponents([.weekday], from: date)
        let weekday = dataComponents.weekday ?? 1
        let before = weekday - 1
        let after = 7 - weekday
        //1647496976
        let share: [Int] = [1647187200000]
        var arr: [Date] = []
        arr.append(contentsOf: createDateArr(count: before, date: date, isAdd: false).reversed())
        arr.append(date)
        arr.append(contentsOf: createDateArr(count: after, date: date, isAdd: true))
        let componts = arr.map({ mCalendar.dateComponents([.day , .month , .year], from: $0)})
        mm_printLog(arr)
    }
    
    static func createDateArr(count: Int, date: Date, isAdd: Bool) -> [Date] {
        guard count > 0 else { return []}
        let dayDistance: TimeInterval = 24 * 60 * 60
        var arr: [Date] = []
        for i in 1...count {
            if isAdd {
                let date = Date(timeInterval: dayDistance * Double(i), since: date)
                arr.append(date)
            } else {
                let date = Date(timeInterval: -dayDistance * Double(i), since: date)
                arr.append(date)
            }
        }
        return arr
    }
}

extension Date {
    public func isSameDay(_ date: Date) -> Bool {
        return Date.mCalendar.isSameDay(self, right: date)
    }
}

extension Calendar {
    public func isSameDay(_ left: Date, right: Date) -> Bool {
        let leftDate = dateComponents([.year, .month, .day], from: left)
        let rightDate = dateComponents([.year, .month, .day], from: right)
        if leftDate == rightDate {
            return true
        }
        return false
    }
}

extension DateComponents {
    var weekStr: String {
        switch weekday {
        case 1:
            return "周日"
        case 2:
            return "周一"
        case 3:
            return "周二"
        case 4:
            return "周三"
        case 5:
            return "周四"
        case 6:
            return "周五"
        case 7:
            return "周六"
        default:
            return "周一"
        }
    }
    
    var yd_year: Int {
        if let y = year {
            return y
        }
        return 2022
    }
    
    var yd_month: Int {
        if let v = month {
            return v
        }
        return 1
    }
    
    var yd_day: Int {
        if let v = day {
            return v
        }
        return 1
    }
}
