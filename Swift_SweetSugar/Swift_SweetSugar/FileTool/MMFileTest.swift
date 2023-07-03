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
        let path = Bundle.main.path(forResource: "90879c75-da87-4b9d-9ab6-9654378198f6", ofType: "txt")
        do {
            let str = try String(contentsOfFile: path!)
            mm_printLog("str->\(str)")
        } catch let e {
            mm_printLog(e)
        }
        
    }
}
