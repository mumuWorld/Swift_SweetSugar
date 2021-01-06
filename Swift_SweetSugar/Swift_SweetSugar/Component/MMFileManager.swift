//
//  MPFileManager.swift
//  MMPlayer
//
//  Created by yangjie on 2019/8/15.
//  Copyright © 2019 Mumu. All rights reserved.
//

import UIKit

enum DirectorType {
    case root
    case docutment
}

struct MMFileItem {
    
    let url: URL
    let isDirectory: Bool
    let fileSize: Int
    
    init(fileURL: URL, resourceKeys: Set<URLResourceKey>) throws {
        let meta = try fileURL.resourceValues(forKeys: resourceKeys)
        self.init(
            fileURL: fileURL,
            isDirectory: meta.isDirectory ?? false,
            fileSize: meta.fileSize ?? 0)
    }
    
    init(
        fileURL: URL,
        isDirectory: Bool,
        fileSize: Int)
    {
        self.url = fileURL
        self.isDirectory = isDirectory
        self.fileSize = fileSize
    }
}

class MMFileManager {
    
    static var cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    
    static var receivedPath = MMFileManager.cachePath?.appendPathComponent(string: "Received")
    
    class func getSandboxPath(fileType: DirectorType = .root) -> String {
        var type:FileManager.SearchPathDirectory = .applicationDirectory
        if fileType == .root {
            return NSHomeDirectory();
        } else if fileType == .docutment {
            type = .documentDirectory
        }
        let path = NSSearchPathForDirectoriesInDomains(type, .userDomainMask, true).first ?? ""
        return path
    }
    
    class func getDirectorAllItems(path: String) -> [String]? {
//        MPPrintLog(message: "path->" + path)
        let manager = FileManager.default
        var items:[String] = Array()
        do {
            items = try manager.contentsOfDirectory(atPath: path)
        } catch {
//            MPErrorLog(message: error)
        }
        return items
    }
    
//    class func getPathProperty(path: String) -> MMFileItem? {
//        if !judgePathIsRight(path: path) {
//            return nil
//        }
//        let manager = FileManager.default
////        MPPrintLog(message: "path->" + path)
//        do {
//            let dict = try manager.attributesOfItem(atPath: path)
//            let item = MMFileItem.init(param: dict)
//            item.path = path
//            return item
//        } catch {
////            MPErrorLog(message: error)
//        }
//        return nil
//    }
    
    
    /// 创建文件夹
    /// - Parameter path: 路径
    class func createDirectory(path: String) {
        if !judgePathIsRight(path: path) {
            return
        }
        let manager = FileManager.default
//        MPPrintLog(message: "path->" + path)
        var pointer = ObjCBool(false)
        let exist = manager.fileExists(atPath: path, isDirectory: &pointer)
        if exist && pointer.boolValue == true {
//            MPPrintLog(message: "文件已经存在")
            return
        }
        do {
            try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
//            printError(error)
//            MPErrorLog(message: error)
        }
    }
    
    
    /// 返回是否存在是否是文件夹
    class func fileOrDirectorExist(path: String) -> (exist: Bool, isDirectory: Bool) {
        if !judgePathIsRight(path: path) {
            return (false,false)
        }
        let manager = FileManager.default
//        MPPrintLog(message: "path->" + path)
        var pointer = ObjCBool(false)
        let exist = manager.fileExists(atPath: path, isDirectory: &pointer)
        return (exist, pointer.boolValue)
    }
    
    
    /// 拷贝文件到路径
    class func copyFileFrom(path: String, toPath: String) {
        if !judgePathIsRight(path: path) || !judgePathIsRight(path: toPath) {
            return
        }
        let fitPath = handleFitPath(path: path)
        let manager = FileManager.default
        do {
            try manager.copyItem(atPath: fitPath, toPath: toPath)
        } catch {
//            MPErrorLog(message: error)
        }
    }
    
    class func judgePathIsRight(path: String) -> Bool {
        if path.count < 1 {
//            MPPrintLog(message: "路径不合法")
            return false
        }
        return true
    }
    
    class func handleFitPath(path: String) -> String {
        var newPath = path
        
        if path.hasPrefix("file:///private") {
            let  range = path.index(path.startIndex, offsetBy: 15)..<path.endIndex
            newPath = String(newPath[range])
        }
        return newPath
    }
    
    
    /// Get the total file size of the folder in bytes.
    class func totalSize(path: String) throws -> UInt {
        
        let propertyKeys: [URLResourceKey] = [.fileSizeKey]
        
        let result = fileOrDirectorExist(path: path)
        if !result.exist {
            return 0
        }
        if !result.isDirectory {
            var fileSize: UInt = 0
            
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: path)
                fileSize = attr[FileAttributeKey.size] as? UInt ?? 0
                
                let dict = attr as NSDictionary
                fileSize = UInt(dict.fileSize())
            } catch {
                print("Error: \(error)")
            }
            return fileSize
        }
        
        let keys = Set(propertyKeys)
        let urls = try allFileURLs(path: path, for: propertyKeys)
        
        let totalSize: UInt = urls.reduce(0) { size, fileURL in
            do {
                let meta = try MMFileItem(fileURL: fileURL, resourceKeys: keys)
                if !meta.isDirectory {
                    return size + UInt(meta.fileSize)
                }
                return size
            } catch {
                return size
            }
        }
        return totalSize
    }
    
    class func allFileURLs(path:String,  for propertyKeys: [URLResourceKey]) throws -> [URL] {
        let fileManager = FileManager.default
        
        
        let directoryURL = URL(fileURLWithPath: path)
        guard let directoryEnumerator = fileManager.enumerator(
                at: directoryURL, includingPropertiesForKeys: propertyKeys, options: .skipsHiddenFiles) else
        {
            throw MMError.fileError(error: .fileNotExist(path: path))
        }
        
        guard let urls = directoryEnumerator.allObjects as? [URL] else {
            throw MMError.fileError(error: .fileNotExist(path: path))
        }
        return urls
    }
    
    class func removeItem(path: String) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
//            printError(error)
        }
    }
}

public enum MMError: Error {
    
    public enum MMFileError {
        case fileNotExist(path: String)
    }
    
    /// 常规错误
    public enum MMNormalError {
        case unknowError(message: String?)
    }
 
    case fileError(error: MMFileError)
    case normalError(error: MMNormalError)
}

extension MMError {
    var reason: String {
        get {
            switch self {
            case .fileError(let error):
                return error.reason
            case .normalError(let error):
                return error.reason
            }
        }
    }
        
    var errorCode: Int {
        get {
            switch self {
            case .fileError(let error):
                return error.errorCode
            case .normalError(let error):
                return error.errorCode
            }
        }
    }
}



extension MMError.MMFileError {
    var reason: String {
        get {
            switch self {
            case .fileNotExist(let path):
                return "路径不存在->\(path)"
            default:
                return "错误"
            }
        }
    }

    var errorCode: Int {
        get {
            switch self {
            case .fileNotExist(_):
                return 1
            default:
                return 0
            }
        }
    }
    
}

extension MMError.MMNormalError {
    var reason: String {
        get {
            switch self {
            case .unknowError(let message):
                return "未知错误->\(message ?? "")"
            default:
                return "错误"
            }
        }
    }

    var errorCode: Int {
        get {
            switch self {
            case .unknowError(_):
                return 1
            default:
                return 0
            }
        }
    }
}
