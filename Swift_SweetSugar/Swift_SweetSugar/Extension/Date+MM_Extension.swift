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
    static let shareFormatter: DateFormatter = DateFormatter()
    
    static func currentTimeStamp() -> Int {
        let time = Date().timeIntervalSince1970
        return Int(time)
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
    
    static func getDayMonthYear(dateStr: String, formate: YDTDateFormatterStr = .yyyyMMddHHmm) -> (day: Int, month: Int, year: Int) {
        formatter.dateFormat = formate.rawValue
        guard let date = formatter.date(from: dateStr) else {
            return (0,0,0)
        }
        return getDMY(with: date)
    }
    
    static func getDMY(with date: Date) -> (day: Int, month: Int, year: Int) {
        let dataComponents = canlendar.dateComponents([.day , .month , .year], from: date)
        let day = dataComponents.day
        let month = dataComponents.month
        let year = dataComponents.year
        return (day ?? 0, month ?? 0, year ?? 0)
    }
}
