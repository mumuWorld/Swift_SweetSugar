//
//  MMHighlightView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/8/21.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

class MMHighlightView: UIView {
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        // 绘制背景
        context.setFillColor(UIColor.yellow.withAlphaComponent(0.2).cgColor)
        context.addRect(rect)
        context.fillPath()
//        context.setAlpha(0.1)
//        context.fill(rect)
        
        
//        let fullTextPath = UIBezierPath(rect: CGRect(origin: .zero, size: rect.size))
        let fullTextPath = UIBezierPath(rect: CGRect(x: 10, y: 10, width: 100, height: 10))
        let fullTextPath_2 = UIBezierPath(rect: CGRect(x: 10, y: 15, width: 100, height: 10))
        fullTextPath.append(fullTextPath_2)
        
        let fullTextPath_3 = UIBezierPath(rect: CGRect(x: 10, y: 35, width: 100, height: 10))
        fullTextPath.append(fullTextPath_3)

        context.addPath(fullTextPath.cgPath)
//        context.setStrokeColor(UIColor.red.cgColor)
        context.setFillColor(UIColor.red.withAlphaComponent(0.1).cgColor)
        context.setBlendMode(.clear)
        context.fillPath()
//        context.strokePath()
//        
        let fullTextPath_10 = UIBezierPath(rect: CGRect(x: 10, y: 30, width: 100, height: 10))
        context.addPath(fullTextPath_10.cgPath)
//        context.setStrokeColor(UIColor.red.cgColor)
//        context.setFillColor(UIColor.green.cgColor)
        context.setBlendMode(.clear)
        //填充路径的区域
        context.fillPath()
        // 绘制path，不会填充
        //context.strokePath()

    }

    /// 绘制全文路径
    func appendSubPath(bezierPath: UIBezierPath, box: String, scale: CGFloat, space_h: CGFloat, space_v: CGFloat) {
//        guard let box = item.boundingBox, !box.isEmpty else { return }
        print("\(box)")
        let arr = box.components(separatedBy: ",")
        guard arr.count == 4, let x = Double(arr[0]), let y = Double(arr[1]), let w = Double(arr[2]), let h = Double(arr[3]) else { return }
        let realRect = CGRect(x: x * scale + space_h, y: y * scale + space_v, width: w * scale, height: h * scale)
        //宽度 + 2
        bezierPath.append(UIBezierPath(roundedRect: realRect, cornerRadius: 2))
    }
}
