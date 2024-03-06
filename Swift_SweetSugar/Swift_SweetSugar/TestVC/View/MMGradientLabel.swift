//
//  MMGradientLabel.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/6/6.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

class MMGradientLabel: UIView {
    
    lazy var label: UILabel = {
        let item = UILabel()
        item.numberOfLines = 1
        item.lineBreakMode = .byTruncatingTail
        return item
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let item = CAGradientLayer()
        //        item.frame = CGRect(x: 0, y: 50, width: 300, height: 300)
        item.colors = [
            UIColor.mm_colorFromHex(color_vaule: 0xAD28FF).cgColor,
            UIColor.mm_colorFromHex(color_vaule: 0x4D74FF).cgColor,
            //            UIColor.mm_colorFromHex(color_vaule: 0x78a0e5).cgColor,
        ]
        item.startPoint =  CGPoint(x: 0, y: 0.5)
        item.endPoint = CGPoint(x: 1, y: 0.5)
        item.locations = [0, 1]
        layer.addSublayer(item)
        return item
    }()
    
    /// 可做最大宽度限制
    var limitSize: CGSize = .zero
    
    //    var textInset: UIEdgeInsets = .zero
    
    override var intrinsicContentSize: CGSize {
        //        var size = label.sizeThatFits(limitSize)
        //        size.width += textInset.left + textInset.right
        //        size.height += textInset.top + textInset.bottom
        //        return CGSize(width: ceil(size.width), height: ceil(size.height))
        return label.sizeThatFits(limitSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = label.layer
    }
    
    convenience init(text: String = "", limitSize: CGSize = .zero, font: UIFont, colors: [UIColor], locations: [NSNumber]? = nil) {
        self.init(frame: .zero)
        label.font = font
        label.text = text
        if let locations {
            gradientLayer.locations = locations
        }
        gradientLayer.colors = colors.map({ $0.cgColor })
        self.limitSize = limitSize
        //        self.textInset = textInset
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        let x = textInset.left
        //        let y = textInset.top
        //        let w = bounds.width - textInset.left - textInset.right
        //        let h = bounds.height - textInset.top - textInset.bottom
        //        let resultRect = CGRect(x: x, y: y, width: w, height: h)
        label.frame = bounds
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        CATransaction.commit()
//        gradientLayer.isHidden = false
//        gradientLayer.mask = label.layer

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MMGradientLabel {
    
    var text: String? {
        get { label.text }
        set {
            label.text = newValue
//            gradientLayer.mask = nil

            invalidateIntrinsicContentSize()
        }
    }
}



class GradientLabel: UILabel {
    var colors: [CGColor] = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let textSize = self.text?.size(withAttributes: [NSAttributedString.Key.font: self.font]) ?? CGSize.zero
        let textRect = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        // 画文字 (不做显示用，主要作用是设置 layer 的 mask)
        textColor.set()
        text?.draw(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        // 坐标 (只对设置后的画到 context 起作用，之前画的文字不起作用)
        context.translateBy(x: 0, y: rect.size.height - (rect.size.height - textSize.height) * 0.5)
        context.scaleBy(x: 1, y: -1)
        
        let alphaMask = context.makeImage()
        context.clear(rect) // 清除之前画的文字
        
        // 设置 mask
        if let alphaMask = alphaMask {
            context.clip(to: rect, mask: alphaMask)
        }
        
        // 画渐变色
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)
        let startPoint = CGPoint(x: textRect.origin.x, y: textRect.origin.y)
        let endPoint = CGPoint(x: textRect.origin.x + textRect.size.width, y: textRect.origin.y + textRect.size.height)
        if let gradient = gradient {
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
    }
}

//class GradientLabel: UILabel {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        updateGradient()
//    }
//    
//    private func updateGradient() {
//        let gradientLayerName = "gradientLayer"
//        
//        // 移除已有的渐变图层（如果有）
//        layer.sublayers?.removeAll(where: { $0.name == gradientLayerName })
//        
//        // 创建一个新的 CAGradientLayer
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.name = gradientLayerName
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [
//            UIColor.red.cgColor, // 起始颜色（可以替换为你想要的颜色）
//            UIColor.blue.cgColor // 结束颜色（可以替换为你想要的颜色）
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        
//        // 将新的渐变图层添加到 UILabel 的 layer 上
//        layer.addSublayer(gradientLayer)
//        
//        // 创建一个遮罩图层，使渐变图层只显示在文本区域
//        let maskLayer = CALayer()
//        maskLayer.contents = UIGraphicsImageRenderer(size: bounds.size).image { _ in
//            drawHierarchy(in: bounds, afterScreenUpdates: true)
//        }.cgImage
//        maskLayer.frame = bounds
//        gradientLayer.mask = maskLayer
//    }
//}
