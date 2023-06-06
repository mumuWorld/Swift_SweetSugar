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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { item in
            item.frame = self.bounds
        }
    }
    
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


/// 简单的渐变View，只能设置自己的渐变色
open class SampleGradientView: UIView {
    
    open var colors = [UIColor(red: 34 / 255.0, green: 38 / 255.0, blue: 56 / 255.0, alpha: 0.15), UIColor(red: 34 / 255.0, green: 38 / 255.0, blue: 56 / 255.0, alpha: 0)] {
        didSet {
            remakeGradient()
        }
    }
    open var locations: [CGFloat] = [0, 1] {
        didSet {
            remakeGradient()
        }
    }
    open var gradient: CGGradient! {
        didSet {
            setNeedsDisplay()
        }
    }
    /// 遮罩角度(0 ~ 360)
    open var degree: Int = 0
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        remakeGradient()
    }
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func remakeGradient() {
        let cfColors = colors.map({ (color) -> CGColor in
            return color.cgColor
        }) as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        gradient = CGGradient(colorsSpace: colorSpace, colors: cfColors , locations: locations)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: self.traitCollection) == true {
                remakeGradient()
                setNeedsDisplay()
            }
        }
    }
    
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        if degree == 90 {
            context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.5), end: CGPoint(x: rect.width, y: 0.5), options: [])
        } else {
            context.drawLinearGradient(gradient, start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: rect.height), options: [])
        }
    }
}
