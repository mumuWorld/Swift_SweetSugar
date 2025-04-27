//
//  UITestVC+Animation.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/7/2.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation


extension UITestVC {
    // add caTransition to transitionImgV
    func addCATransition(subType: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .reveal
        transition.subtype = subType
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        transitionImgV.image = UIImage(named: "tab_arrow_up")
        testButton.imageView?.layer.add(transition, forKey: nil)
    }
    
    func testVideoImage() {
        TestTool().testImg { [weak self] img, color in
            guard let self = self else { return }
            self.tmpImageView.image = img
            self.view.backgroundColor = color
        }
    }
}
