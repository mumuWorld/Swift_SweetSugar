//
//  UITestVC+Test.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/2/9.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

extension UITestVC {
    func labelTest() {
        let pg = NSMutableParagraphStyle()
        pg.lineBreakMode = .byTruncatingTail
        
        let attr = NSMutableAttributedString(string: "0123")
        attr.addAttribute(.paragraphStyle, value: NSMutableParagraphStyle(), range: NSRange(location: 0, length: 4))
        
        let attr_2 = NSMutableAttributedString(string: "456")
        attr_2.addAttribute(.paragraphStyle, value: pg, range: NSRange(location: 0, length: 3))
        
        attr.append(attr_2)
        
        widthLabel.attributedText = attr
    }
}
