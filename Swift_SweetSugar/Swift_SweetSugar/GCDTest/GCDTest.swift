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
        ser.async {
            mm_printLog(message: "1")
            DispatchQueue.global().async {
                mm_printLog(message: "2")
                DispatchQueue.main.async {
                    mm_printLog(message: "3")
                }
            }
        }
    }
}
