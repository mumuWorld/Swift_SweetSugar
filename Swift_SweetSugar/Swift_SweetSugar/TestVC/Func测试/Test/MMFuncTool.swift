//
//  MMFuncTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/27.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class MMFuncTool {
    func past() {
//        UIPasteboard.general.string = "http://hellow world"
        let pasted = UIPasteboard.general
        if #available(iOS 14.0, *) {
            pasted.detectPatterns(for: Set(arrayLiteral: UIPasteboard.DetectionPattern.probableWebSearch, .probableWebURL, .number)) { result in
                switch result {
                case .success(let results):
                    for item in results {
                        if item == .probableWebSearch {
                            mm_printLog("测试1")
                        } else if item == .number {
                            mm_printLog("测试2")
                        } else if item == .probableWebURL {
                            mm_printLog("测试3")
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        } else {
            
        }
        mm_printLog("str->\(pasted.string)")
        mm_printLog("str->\(pasted.strings)")

    }
    
    func makeData(s: String) {
//        s.data(using: .utf8).map {
////            JSONSerialization.jsonObject(with: <#T##Data#>, options: <#T##JSONSerialization.ReadingOptions#>)
//            try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed)
//        }?.map({
//            MMFuncTool()
//        })
    }
    
    func operationQueueTest() {
        let operation = Operation()
        operation.completionBlock = {
            mm_printLog("finished")
        }
        OperationQueue.main.addOperation(operation)
        
        MMFuncTool.add(a: 1, b: 3) { result in
            mm_printLog(result)
        }
    }
    
    static func add(a: Int, b: Int, block: @escaping ((Int) -> Void)) {
        OperationQueue.main.addOperation {
            block(a + b)
        }
    }
    
    
//    var dataArray: [Data] = [Data]()
    var dataArray: [String] = [String]()

    
    let backQueue = DispatchQueue(label: "com.mumu.back")
    
    func arrayTest() -> Void {
        //串行执行，但是不会执行100000次，
//        for i in 0...100000 {
//            backQueue.async {
//                self.dataArray.append(String(format: "%d", i))
//                mm_printLog(i)
//            }
//        }
        
//        backQueue.async {
//            for i in 0...100000 {
//            self.dataArray.append(String(format: "%d", i))
//            mm_printLog(i)
//            }
//        }
//        var preArr: [Int] = []
//        preArr.reserveCapacity(100)
//        // capacity = 100
//        preArr.append(1)
//        //会移除所申请的空间 capacity = 0
//        preArr.removeAll()
        
//        let removeArr1: [Int] = [0,1,2,3,4,5]
        //会全部filter一遍
//        let tmpArr = removeArr1.filter { item in
//            mm_printLog("item->\(item)")
//            return item < 4
//        }.prefix(2).map({ $0 * 2 })
        
        
        var removeArr: [Int] = [0,1,2,3,4,5]
        //保留【1，5】
        removeArr.removeSubrange(1..<(removeArr.count - 1))
        var removeArr2: [Int] = [0,1]
        //不变
        removeArr2.removeSubrange(1..<(removeArr2.count - 1))
        var removeArr3: [Int] = [0]
        //Thread 1: Fatal error: Range requires lowerBound <= upperBound
//        removeArr3.removeSubrange(1..<(removeArr3.count - 1))
        
        var emptyArr: [Int] = []
        //不会崩， item = nil
        let item = emptyArr.last
        //不会crash
        emptyArr.removeAll()
        //会crash
//        emptyArr.removeFirst()
        mm_printLog("")
        
        let array: [String] = []
        let index = (array.startIndex..<array.endIndex)
        let c1 = index.contains(0)
        mm_printLog("")
    }
    
    func deviceInfo() -> Void {
        let device = UIDevice.current
        let name = device.name
        let model = device.model
        var systemInfo: utsname = utsname()
        uname(&systemInfo)
        //第一种方法
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //第二种方法
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
            
//        systemInfo.sysname.withUnsafeBufferPointer { ptr in
//                 let s = String(validatingUTF8: ptr.baseAddress!)
//               print(s)
//        }
//        let machine = String(cString: sname.machine)
//        let machine = String(cString: sname.sysname)
        mm_printLog(identifier)
    }
    
    func jsonTest() {
        let path = Bundle.main.path(forResource: "result", ofType: "json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try JSON(data: data)
            let typos = try JSONDecoder().decode([Typo].self, from: json["typos"]["typo"].rawData())
            mm_printLog(typos)
        } catch(let e) {
            mm_printLog(e)
        }
    }
    
    func foo() {
        
    }
}

extension MMFuncTool {
    func rangeTest() {
        //直接crash： Thread 1: Fatal error: Range requires lowerBound <= upperBound
//        let range = 10..<5
        let range = 0..<5
        let range_2 = 5..<10
        
        var v = 10
        //21
        v += 10 + 1
        v = 10
        //-1
        v -= 10 + 1
        v = 10
        //1
        v -= 10 - 1
        mm_printLog("")
        
        MMLocationManager.shared.startOnceLocation { type, item in
            mm_printLog(item)
        }
    }
    
    func secretTest() {
        let text = "appid=1657835537language=zh-Hanslocation=WX4FBXXFKE4Ftimestamp=1642663075000unit=c"
        let key = "M5B14dsPBVAjt0p5"
        let r = MMSecret().hmac_sha1(key: key, text: text)
        let r2 = MMSecret().hmac_sha1_2(key: key, text: text)
        mm_printLog(r + r2)
    }
    
    func testAnaly() {
//        let path = Bundle.main.path(forResource: "AREACODE", ofType: "txt")!
//        let str = try? String(contentsOfFile: path)
//        let AREACODE = str?.components(separatedBy: "\n") ?? []
        
        let path_2 = Bundle.main.path(forResource: "allcity", ofType: "txt")!
        let str_2 = try? String(contentsOfFile: path_2)
        let allcity = str_2?.components(separatedBy: "\n") ?? []
        
        let result = allcity.map { item -> MMCity in
            let arr = item.components(separatedBy: "\t")
            return MMCity(arr: arr)
        }
        let data = try? JSONEncoder().encode(result)
        let savePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let filePath = savePath.appendPathComponent(string: "cityList.data")
        let url = URL(fileURLWithPath: filePath)
//        try? data?.write(to: url, options: .atomic)
        
        //读取
        guard let readData = try? Data(contentsOf: url, options: .alwaysMapped) else { return }
        let modelArr = try? JSONDecoder().decode([MMCity].self, from: readData)
        
        mm_printLog(modelArr)
    }
}

struct MMCity: Codable {
    var cityArea: String = ""
    var cityId: String = ""
    var cityEn: String = ""
    var cityCn: String = ""
    var districtEn: String = ""
    var districtCn: String = ""
    var provEn: String = ""
    var provCn: String = ""
    
    init(arr: [String]) {
        cityArea = arr[0]
        cityId = arr[1]
        cityEn = arr[2]
        cityCn = arr[3]
        districtEn = arr[4]
        districtCn = arr[5]
        provEn = arr[6]
        provCn = arr[7]
    }
}

struct Typo: Codable {
    public var word: String?
    public var trans: String?
}

extension MMFuncTool {
 
}


protocol MMEmptyProtocol {
    func testPrint()
}

extension MMEmptyProtocol {
    func testPrint() {
        mm_printLog(self)
//        #define PTHREAD_MUTEX_NORMAL        0
//        #define PTHREAD_MUTEX_ERRORCHECK    1
//        #define PTHREAD_MUTEX_RECURSIVE        2
//        #define PTHREAD_MUTEX_DEFAULT        PTHREAD_MUTEX_NORMAL
//        var mutex_lock: pthread_mutex_t/
//        var mutex_attr: pthread_mutexattr_t
//
//        pthread_mutexattr_init(&mutex_attr)
//        pthread_mutexattr_settype(&mutex_attr, PTHREAD_MUTEX_NORMAL)
//        pthread_mutex_init(&mutex_lock, &mutex_attr)
    }
    
    func testPrint2() {
        mm_printLog("222")
    }
    
    func testPrint3() {
        mm_printLog("333")
    }
}

extension MMFuncTool: MMEmptyProtocol {
    func testPrint2() {
        mm_printLog("111")
    }
}

extension FuncTestVC: MMEmptyProtocol {}


