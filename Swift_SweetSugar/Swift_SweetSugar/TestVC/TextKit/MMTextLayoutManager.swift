//
//  MMTextLayoutManager.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/2/8.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import UIKit

class MMTextLayoutManager: NSLayoutManager {
    override init() {
        super.init()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
        
        
    }
}

extension MMTextLayoutManager: NSLayoutManagerDelegate {
//    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
//        mm_printLog("test->\(glyphIndex), \(rect)")
//        return CGFloat(glyphIndex * 1);
//    }
}
