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
//        let date = Date()
        let date = Date.getDate(dateStr: "2022-01-23", format: .ShortYMD)
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
}
