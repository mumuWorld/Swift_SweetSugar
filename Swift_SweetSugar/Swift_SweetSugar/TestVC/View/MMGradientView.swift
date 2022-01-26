//
//  MMGradientView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/26.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class MMGradientView: UIView {

    lazy var graintLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(graintLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        graintLayer.frame = CGRect(origin: .zero, size: mm_size)
    }
    
    func update(colors: [UIColor], start: CGPoint = CGPoint(x: 0.5, y: 0), end: CGPoint = CGPoint(x: 0.5, y: 1), locations: [CGFloat]? = nil) {
        graintLayer.colors = colors.map({ (color) -> CGColor in
            return color.cgColor
        }) as [Any]
        graintLayer.startPoint = start
        graintLayer.endPoint = end
        if let loc = locations as [NSNumber]? {
            graintLayer.locations = loc
        }
    }
}
