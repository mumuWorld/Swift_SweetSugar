//
//  CALayer+Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/8/5.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation

extension CALayer {
    
    /// width
    var mm_width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
}
