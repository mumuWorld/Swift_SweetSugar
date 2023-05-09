//
//  MMLabel.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/4/23.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

class MMLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        get {
            let size = super.intrinsicContentSize
            //frame (0.0, 0.0, 0.0, 0.0),
            mm_printLog("test->\(size),\(self.preferredMaxLayoutWidth), \(self.bounds)")
            return size
        }
    }
    
    
}
