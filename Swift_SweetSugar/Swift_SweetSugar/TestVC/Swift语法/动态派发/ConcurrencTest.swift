//
//  ConcurrencTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/11/28.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation

class MMConcurrencyTest {
    
    func test() {
        Task {
            do {
                try await mainTest()
            } catch {
                print("test->error:\(error)")
            }
        }
    }
    
    func mainTest() async throws {
        let baiduURL = URL(string: "https://www.baidu.com")!
        
        let handle = Task {
            // 会走
            print("test-> 不会调用0")
            let (data1, response1) = try await URLSession.shared.data(from: baiduURL)
            print("test-> 不会调用1",data1.count)
            let (data2, response2) = try await URLSession.shared.data(from: baiduURL)
            print("test-> 不会调用2", data2.count)
        }
        
        print("test-> 调用0")

        handle.cancel()
    }
    
    func downTest() async throws {
        let endpointURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!

        if #available(iOS 15.0, *) {
            let (location, response) = try await URLSession.shared.download(from: endpointURL)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 /* OK */ else {
                throw MMError.fileError(error: .fileNotExist(path: "test"))
            }
            let newLocation = URL(fileURLWithPath: "/tmp/test.csv")
            try FileManager.default.moveItem(at: location, to: newLocation)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func notifyTest() async {
        let center = NotificationCenter.default
        if #available(iOS 15, *) {
            let notification = await center.notifications(named: .NSPersistentStoreRemoteChange).first {
                $0.userInfo?["NSStoreUUIDKey"] as! String == "testst"
            }
        } else {
        }
    }
    
    func linesTest() async throws {
        let endpointURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!
        
        // 跳过首行 因为是header描述不是地震数据
        // 接着遍历提取强度、时间、经纬度信息
        if #available(iOS 15.0, *) {
            // linse 可以直接读取 文件
            for try await event in endpointURL.lines.dropFirst() {
                let values = event.split(separator: ",")
                let time = values[0]
                let latitude = values[1]
                let longtitude = values[2]
                let magnitude = values[4]
                print("Magnitude \(magnitude) on \(time) at \(latitude) \(longtitude)")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func awiTest() {
        
    }
    
    func listPhotos() async -> String {
//        Task.sleep(nanoseconds: 1000000)
        return ""
    }
}
