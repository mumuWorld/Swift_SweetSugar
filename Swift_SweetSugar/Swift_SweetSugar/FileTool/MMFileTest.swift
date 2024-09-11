//
//  MMFileToos.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2021/1/4.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation

class MMFileTest {
    
    static var audioPath: String = {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let savePath = (path ?? "") + "/Audio/"
        return savePath
    }()
    
    class func create() {
        MMFileManager.createDirectory(path: audioPath)
        mm_printLog(audioPath)
    }
    
    class func itemProperty() throws {
        
        let itemPath = audioPath.appendPathComponent(string: "1.mp3")
        
        guard let url = URL(string: itemPath) else {
            throw MMError.fileError(error: .fileNotExist(path: itemPath))
        }
        
        let fileUrl = URL(fileURLWithPath: itemPath)
        
        let manager = FileManager.default
        let keys: [URLResourceKey] = [.fileSizeKey]
        let set = Set(keys)
        let data = try url.resourceValues(forKeys: set)
 
        let attr = try manager.attributesOfItem(atPath: itemPath)

        mm_printLog(data)
        mm_printLog(attr)

    }
    
    class func direcotryProperty() throws {
        let itemPath = audioPath
        // /Users/mumu/Library/Developer/CoreSimulator/Devices/E3124373-15D9-4F66-831F-0739AF95610C/data/Containers/Data/Application/62CC57CC-480B-48CB-8A1E-5CF3DAAD8CAA/Library/Caches/Audio/
        guard let url = URL(string: itemPath) else {
            throw MMError.fileError(error: .fileNotExist(path: itemPath))
        }
        
        // file:///Users/mumu/Library/Developer/CoreSimulator/Devices/E3124373-15D9-4F66-831F-0739AF95610C/data/Containers/Data/Application/62CC57CC-480B-48CB-8A1E-5CF3DAAD8CAA/Library/Caches/Audio/
        let fileUrl = URL(fileURLWithPath: itemPath)
        
        let manager = FileManager.default
        
        let enumerator = manager.enumerator(at: fileUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles) { (url, error) -> Bool in
            mm_printLog("测试")
            return true }
        guard let directoryEnumerator = enumerator  else {
            return
        }
        
        guard let urls = directoryEnumerator.allObjects as? [URL] else {
            return
        }
        
        mm_printLog(urls)
    }
    
    func testF_1() -> Void {
        do {
            mm_printLog("1")
            try throwTestFunc()
            mm_printLog("2")
        } catch let err as MMError {
            mm_printLog("4")
            mm_printLog(err.reason)
        } catch let _ as MMError.MMNormalError {
            
        } catch {
            mm_printLog("3")
        }
    }
    
    func throwTestFunc() throws  -> Void {
        mm_printLog("test")
        throw MMError.normalError(error: MMError.MMNormalError.unknowError(message: "test"))
    }
    
    func readStr_40() {
//        let path = Bundle.main.path(forResource: "90879c75-da87-4b9d-9ab6-9654378198f6", ofType: "txt")
//        do {
//            let str = try String(contentsOfFile: path!)
//            mm_printLog("str->\(str)")
//        } catch let e {
//            mm_printLog(e)
//        }
//        pathTest()
        // 删除测试
        deleTest()
    }
    
    func pathTest() {
        // 删除文件 要判断文件是否存在
        do {
            //file:///var/mobile/Containers/Data/Application/E6EE6F05-7491-4D3D-AE7D-BA4EB1E661B1/Library/Caches/
            var path = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            "/var/mobile/Containers/Data/Application/E6EE6F05-7491-4D3D-AE7D-BA4EB1E661B1/Library/Caches"
            var path_2 = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
            mm_printLog("end_1")
//            if #available(iOS 16.0, *) {
//                path.append(path: "text.text")
//                print("test->path:\(path.absoluteString)")
//                ///var/mobile/Containers/Data/Application/69B5E978-D6E9-4CF7-B70E-B10EE3F6311B/Library/Caches/text.text
//                try FileManager.default.removeItem(at: path)
//            }
            path_2.append("/test.txt")
            if FileManager.default.fileExists(atPath: path_2) {
//                try FileManager.default.removeItem(atPath: path_2)
                print("test->删除文件成功")
            } else {
                let result = FileManager.default.createFile(atPath: path_2, contents: nil)
                mm_printLog("test->创建结果 \(result)")
            }
            // 此行代码没问题
            //            try "testword".write(toFile: path_2, atomically: true, encoding: .utf8)

            let arr = [["keysd": "etstt"], ["keyd": "etstt", "key2": "vasdf"]]
            let data = try arr.reduce(Data()) { partialResult, item in
                let itemData = try JSONSerialization.data(withJSONObject: item, options: .fragmentsAllowed)
                var _result = partialResult + itemData
                if let endLine = "\n".data(using: .utf8) {
                    _result.append(endLine)
                }
                return _result
            }
            
//            var data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
//            if let endLine = "\n".data(using: .utf8) {
//                data.append(endLine)
//            }
//            var string = String(data: data, encoding: .utf8)!
//            if let writeData = string.data(using: .utf8) {
                let fileHandle = FileHandle(forWritingAtPath: path_2)
                fileHandle?.seekToEndOfFile()
                fileHandle?.write(data)
                fileHandle?.closeFile()
//            }
        } catch let error {
            print("test->删除文件失败:\(error)")
        }
        mm_printLog("end")
    }
    
    func deleTest() {
        // 先创建
        let path = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent("test")
        if !FileManager.default.fileExists(atPath: path.path) {
            do {
                try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("test->创建失败: \(error)")
            }
        }
        //  path: file:///var/mobile/Containers/Data/Application/655237F4-B1A8-4DEE-8A51-5E97F21B7612/Documents/test/
        // path.path: "/var/mobile/Containers/Data/Application/655237F4-B1A8-4DEE-8A51-5E97F21B7612/Documents/test"
        FileManager.default.deleteFolder(folderPath: path.path)
    }
}

public extension FileManager {
    func deleteFolder(folderPath: String) {
        if fileExists(atPath: folderPath) {
            let childFilePath = subpaths(atPath: folderPath)
            for path in childFilePath! {
                let fileAbsoluePath = folderPath + "/" + path
                try? removeItem(atPath: fileAbsoluePath)
            }
        }
    }
}
