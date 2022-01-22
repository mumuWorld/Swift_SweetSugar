//
//  MMSecret.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/20.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import CommonCrypto

class MMSecret {
    func hmac_sha1(key: String, text: String) -> String {
        guard let keyData = key.data(using: .utf8) as NSData?,
                  let textData = text.data(using: .utf8) as NSData? else { return "" }
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
        let length = Int(CC_SHA1_DIGEST_LENGTH)
        var cHMAC = [UInt8](repeating: 0, count: length)
        CCHmac(algorithm, keyData.bytes, keyData.length, textData.bytes, textData.length, &cHMAC)
        
        let data = Data(bytes: &cHMAC, count: length)
        let base64Str = data.base64EncodedString()
        return base64Str
    }
    
    func hmac_sha1_2(key: String, text: String) -> String {
        guard let keyData = key.data(using: .utf8), let textData = text.data(using: .utf8) else { return "" }
        var bytes = [UInt8](keyData)
        var textBytes = [UInt8](textData)
        
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
        let length = Int(CC_SHA1_DIGEST_LENGTH)
        var cHMAC = [UInt8](repeating: 0, count: length)

        CCHmac(algorithm, &bytes, bytes.count, &textBytes, textBytes.count, &cHMAC)
        
        let data = Data(bytes: &cHMAC, count: length)
        let base64Str = data.base64EncodedString()
        return base64Str
    }
}
