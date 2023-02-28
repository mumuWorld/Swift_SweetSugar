//
//  NetTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/7/7.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import UIKit

protocol NetProtocol {
    
}

class NetTest {
    let boundary = "----WebKitFormBoundary2fl2CixmrVUrUf3A"
    //    var word : any NetProtocol? = nil
    func writetest() {
        let data = boundary.data(using: .utf8)
        let url = URL(fileURLWithPath: "/Users/yangjie01/Desktop/test/pig.data")
        do {
            try data?.write(to: url)
        } catch {
            mm_printLog(error)
        }
        mm_printLog("finish")
    }
    
    func mulitRequest() {
        //        writetest()
        decodeData()
        return
        var req = URLRequest(url: URL(string: "http://pigai-core-test.site.youdao.com/dewarp_api")!)
        req.httpMethod = "POST"
        
        let body = createData()
        req.httpBody = body
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //        req.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
            
        //        let task = URLSession.shared.uploadTask(with: req, from: body) { data, res, error in
        //            mm_printLog(res)
        //        }
        let task = URLSession.shared.dataTask(with: req) { data, res, error in
            //            let all = res
            if let _data = data {
                let url = URL(fileURLWithPath: "/Users/yangjie01/Desktop/test/pig.data")
                do {
                    try _data.write(to: url)
                } catch {
                    mm_printLog(error)
                }
                //                let json = try? JSONSerialization.jsonObject(with: _data, options: .fragmentsAllowed)
                //                mm_printLog(json)
            }
            mm_printLog(res)
        }
        task.resume()
    }
    
    func createData() -> Data {
        let img = UIImage(named: "test")
        let imgData = img?.jpegData(compressionQuality: 0.6) ?? Data()
        mm_printLog("trest->\(imgData.count)")
        var body = Data()
        let param: [String: Any] = [
            "action": "dewarp_api",
            "dewarp": "default",
            "knowledge_domain": "renjiao",
            "do_search": "no",
            "detail": "1",
            "code": "None",
            "raw": "None",
            "image": imgData,
            "image_url": "",
        ]
        //        param.forEach { key, val in
        
        //        }
        for key in param.keys {
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            mm_printLog("test->\(key)")
            let val = param[key]
            if key == "image" {
                body.append("Content-Disposition: form-data; name=\"image\"; filename=\"test.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imgData)
            } else if key == "detail" {
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append(("1").data(using: .utf8)!)
            } else {
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append((val as? String ?? "").data(using: .utf8)!)
            }
        }
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        return body
    }
    
    func decodeData() {
        let url = URL(fileURLWithPath: "/Users/yangjie01/Desktop/test/dewarp_api")
        
        //        Content-Type: multipart/form-data; boundary=b6e684a66d33949bd44624bb1fb7119f
        let resBoundary = "b6e684a66d33949bd44624bb1fb7119f"
        let res_bdy_data = resBoundary.data(using: .utf8)!
        do {
            let data = try Data(contentsOf: url)
            if let multiparts = data.multipartArray(withBoundary: resBoundary, key: "Content-Disposition:") {
                for part in multiparts {
                    if part.contentName == "detail" {
                        var a = try? JSONDecoder().decode(YDPigDetail.self, from: part.data)
                        mm_printLog(a?.fitPoints)
                    } else if part.contentName == "image" {
                        let imageData = part.data
                        //                        let img = UIImageView(image: UIImage(data: imageData))
                    }
                    mm_printLog(part)
                }
            }
            
        } catch {
            mm_printLog(error)
        }
        
    }
}

extension NetTest {
    
}

struct YDPigDetail: Codable {
    var points: [[Int]] = []
    
    enum CodingKeys: String, CodingKey {
        case points
    }
    
    private lazy var _fitPoints: [CGPoint] = []
    var fitPoints: [CGPoint] {
        mutating get {
            if !_fitPoints.isEmpty {
                return _fitPoints
            }
            if points.count == 6 {
                points.removeSubrange(2...3)
            }
            _fitPoints = points.map({ ints in
                if ints.count == 2 {
                    return CGPoint(x: max(ints[0], 0), y: max(ints[1], 0))
                }
                return .zero
            })
            return _fitPoints
        }
    }
}


//            let bufferSize = 1024
//            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
//
//            let stream = InputStream(data: data)
//            stream.open()
//            defer {
//                buffer.deallocate()
//                stream.close()
//            }
//            while stream.hasBytesAvailable {
//                let read = stream.read(buffer, maxLength: bufferSize)
//                if read > 0 {
//                    mm_printLog("test->")
//                } else if read == 0 {
//                    mm_printLog("test->0")
//                } else {
//                    mm_printLog("test->error")
//                }
//            }
