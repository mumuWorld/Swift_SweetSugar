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
    
    convenience init(text: String = "", limitSize: CGSize = .zero, font: UIFont, colors: [UIColor]) {
        self.init(frame: .zero)
        label.font = font
        label.text = text
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
        gradientLayer.frame = bounds
        label.frame = bounds
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
            invalidateIntrinsicContentSize()
        }
    }
}
