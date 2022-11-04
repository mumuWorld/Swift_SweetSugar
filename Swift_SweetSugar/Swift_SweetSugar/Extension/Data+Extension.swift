//
//  Data+Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/7/8.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
//MARK: 解析 multipart 数据
extension Data {
    
    func multipartArray(withBoundary boundary: String, key: String = "Content-Disposition:") -> [YDMultipartItem]? {

        func extractBody(_ data: Data) -> Data? {
            guard let startOfLine = key.data(using: .utf8) else { return nil }
            guard let endOfLine = "\r\n".data(using: .utf8) else { return nil }
            var result: Data? = nil
            var pos = data.startIndex
            while let r1 = data[pos...].range(of: startOfLine)
            {
                if let r2 = data[r1.upperBound...].range(of: endOfLine) {
                    pos = r2.upperBound
                }
            }
            
            if pos < data.endIndex {
                result = data[(pos+2)...]
            }
            return result
        }
        
        let multiparts = components(separatedBy: ("--" + boundary))
        var result: [YDMultipartItem]? = nil
        for part in multiparts
            .enumerated()
            .map({ index, data -> Data in
                if index == multiparts.count-1 {
                    return data.dropLast(2)
                } else {
                    return data
                }
            }) {
            for contentTypeData in part.slices(between: key, and: "\r") {
                if let nameStr = String(data: contentTypeData, encoding: .utf8),
                   let body = extractBody(part)
                {
                    if result == nil {
                        result = [YDMultipartItem]()
                    }
                    let item = YDMultipartItem(nameStr: nameStr, type: "", data: body)
                    result?.append(item)
                } else {
                    continue
                }
            }
        }
        return result
    }
    
    func slices(between from: String, and to: String) -> [Data] {
        guard let from = from.data(using: .utf8) else { return [] }
        guard let to = to.data(using: .utf8) else { return [] }
        return slices(between: from, and: to)
    }
    
    func slices(between from: Data, and to: Data) -> [Data] {
        var chunks: [Data] = []
        var pos = startIndex
        while let r1 = self[pos...].range(of: from),
              let r2 = self[r1.upperBound...].range(of: to)
        {
            chunks.append(self[r1.upperBound..<r2.lowerBound])
            pos = r1.upperBound
        }
        return chunks
    }
    
    func components(separatedBy separator: String) -> [Data] {
        guard let separator = separator.data(using: .utf8)  else { return [] }
        return components(separatedBy: separator)
    }
    
    func components(separatedBy separator: Data) -> [Data] {
        var chunks: [Data] = []
        var pos = startIndex
        while let r = self[pos...].range(of: separator) {
            if r.lowerBound > pos {
                chunks.append(self[pos..<r.lowerBound])
            }
            pos = r.upperBound
        }
        if pos < endIndex {
            chunks.append(self[pos..<endIndex])
        }
        return chunks
    }
}

struct YDMultipartItem {
    var contentName: String = ""
    var contentType: String = ""
    let data: Data
    
    init(nameStr: String?, type: String, data: Data) {
        if nameStr?.isEmpty == false , let arr = nameStr?.components(separatedBy: "name=") {
            if arr.count > 1, let _tmpName = arr.last {
                contentName = Self.removeYinHao(iStr: _tmpName)
            }
        }
        self.data = data
    }
    
    static func removeYinHao(iStr: String) -> String {
        var tmp = iStr
        if tmp.starts(with: "\"") {
            tmp = tmp.substring(from: 1)
        }
        if tmp.hasSuffix("\"") {
            tmp = tmp.substring(to: tmp.count - 1)
        }
        return tmp
    }
}

