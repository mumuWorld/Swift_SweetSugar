//
//  MMControlView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/28.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMControlView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .gray
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        mm_printLog("beginTracking->")
//        guard let gestureRecognizers = touch.gestureRecognizers else { return true }
//        for ges in gestureRecognizers {
//            ges.cancelsTouchesInView = false
//        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        mm_printLog("endTracking->")
    }
    
    override func cancelTracking(with event: UIEvent?) {
        mm_printLog("cancelTracking->")
    }

}
