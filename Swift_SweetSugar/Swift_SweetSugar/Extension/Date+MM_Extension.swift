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
}

extension Date {
    static let shareFormatter: DateFormatter = {
        let item = DateFormatter()
        item.locale = Locale.current
        item.timeZone = TimeZone.current
        return item
    }()
    
    static let mCalendar = Calendar(identifier: .gregorian)

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
}
