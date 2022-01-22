//
//  MMTextStorage.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/17.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class MMTextStorage: NSTextStorage {
    
    // 两个 getter 和两个setter
    override var string: String {
        return ""
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return super.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        super.replaceCharacters(in: range, with: str)
        let mutableStyle = NSMutableParagraphStyle()
//        mutableStyle.
    }
    
    override func setAttributedString(_ attrString: NSAttributedString) {
        super.setAttributedString(attrString)
    }
}
