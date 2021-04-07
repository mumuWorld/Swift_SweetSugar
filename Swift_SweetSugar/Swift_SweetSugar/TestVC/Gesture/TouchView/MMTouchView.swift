//
//  MMTouchView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/4/7.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMTouchView: UIView {

    var highlightColor: UIColor = UIColor(white: 0, alpha: 0.5)
    
    lazy var highlightLayer: CALayer = {
        let hl = CALayer()
        hl.backgroundColor = highlightColor.cgColor
        hl.cornerRadius = layer.cornerRadius
        hl.frame = layer.bounds
        layer.insertSublayer(hl, at: 0)
        return hl
    }()
    
    func handleHighlight(_ isHighlight: Bool = false) -> Void {
        highlightLayer.backgroundColor = isHighlight ? highlightColor.cgColor : (backgroundColor?.cgColor ?? UIColor.white.cgColor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleHighlight(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleHighlight(false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleHighlight(false)
    }
}
