//
//  GCDTest.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/11/25.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class GCDTest {
    func test1() -> Void {
        let ser = DispatchQueue(label: "serial")
        let con = DispatchQueue(label: "con", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
//        ser.async {
//            mm_printLog("1")
            DispatchQueue.global().async {
                mm_printLog("2")
                DispatchQueue.main.async {
                    mm_printLog("3")
                }
                DispatchQueue.main.sync {
                    mm_printLog("4")
                }
                mm_printLog("5")
            }
        }
//    }
    
    func test2() {
        let ser = DispatchQueue(label: "serial")
        let con = DispatchQueue(label: "con", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        ser.async {
            mm_printLog("1, \(Thread.current)")
            con.sync {
                mm_printLog("2, \(Thread.current)")
            }
        }
        sleep(1)
        ser.async {
            mm_printLog("3, \(Thread.current)")
            DispatchQueue.global().sync {
                mm_printLog("4, \(Thread.current)")
            }
        }
    }
}
