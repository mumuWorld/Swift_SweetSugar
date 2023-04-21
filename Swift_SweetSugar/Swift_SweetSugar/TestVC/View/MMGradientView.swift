//
//  MMGradientView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/26.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

public class MMGradientView: UIView {
    
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var _colors: [UIColor] = []
    
    var _adaptDark: Bool = false
    
    public func update(colors: [UIColor], start: CGPoint = CGPoint(x: 0.5, y: 0), end: CGPoint = CGPoint(x: 0.5, y: 1), locations: [CGFloat]? = nil, adaptDark: Bool = false) {
        _colors = colors
        _adaptDark = adaptDark
        guard let graintLayer = self.layer as? CAGradientLayer  else { return }
        graintLayer.colors = colors.map({ (color) -> CGColor in
            return color.cgColor
        }) as [Any]
        graintLayer.startPoint = start
        graintLayer.endPoint = end
        if let loc = locations as [NSNumber]? {
            graintLayer.locations = loc
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard _adaptDark else { return }
        if #available(iOS 13.0, *), previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            guard let graintLayer = self.layer as? CAGradientLayer  else { return }
            graintLayer.colors = _colors.map({ (color) -> CGColor in
                return color.cgColor
            }) as [Any]
        }
    }
}
