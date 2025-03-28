//
//  MMNetWorkManager.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/2/6.
//  Copyright © 2025 Mumu. All rights reserved.
//

import Foundation
import Alamofire

class MMNetWorkManager {
    
     static let shared: MMNetWorkManager = MMNetWorkManager()
    
    func fetchData(from url: String) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate()
                .response { response in
                    if let contentType = response.response?.mimeType {
                        print("📢 服务器 Content-Type: \(contentType)")
                    }
                }
                .responseData { response in
                        switch response.result {
                        case .success(let data):
                            continuation.resume(returning: data)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                }
        }
    }
    
    func request() {
        Task {
            do {
                let url = "https://dict.youdao.com/pronounce/base?client=iphonepro&imei=eb13da6da08b512ecd072e7654d21e15&phonetic=&appleGuest=0&abtest=2&dev_name=iPhone&idfa=66CE6B74-EBA9-4CD1-BDE7-34561E0D227C&appVersion=10.1.24&le=en&caid=43d55393556257b11d3ddcb4a2ad51d5&yduuid=eb13da6da08b512ecd072e7654d21e15&add_param_s_g_1=6B21B019-C002-4CAB-9EA4-F6C289C42B5D&vendor=AppStore&type=2&mysticTime=1738822820533&pointParam=add_param_s_g_0,add_param_s_g_1,mysticTime&mid=18.3&network=wifi&deviceName=iPhone&keyfrom=mdict.10.1.24.iphonepro&model=iPhone11,2&add_param_s_g_0=2D527D16-B3F4-42AE-9A1C-199F84F8D83B&word=February&screen=375x812&keyid=voiceDictAppIos&sign=00729F67E6DCD407C5DCD865B35AAA24&product=mdict"
                let result = try await fetchData(from: url)
                print("✅ 获取数据成功: \(String(describing: result))")
            } catch {
                print("❌ 请求失败: \(error.localizedDescription)")
            }
             
        }
    }
}
