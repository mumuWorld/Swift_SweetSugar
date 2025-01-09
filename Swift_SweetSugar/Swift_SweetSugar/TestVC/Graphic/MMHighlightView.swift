//
//  MMHighlightView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/8/21.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

/// 透明、高亮绘制
class MMHighlightView: UIView {
    
    var path: UIBezierPath? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        // 绘制背景
//        context.setFillColor(UIColor.yellow.withAlphaComponent(0.5).cgColor)
//        context.setFillColor(UIColor.clear.cgColor)
//        context.addRect(rect)
//        context.fillPath()
//        context.setAlpha(0.1)
//        context.fill(rect)
        
        // 不能用这种全路径的方式创建后，再去添加子路径。
//        let fullTextPath = UIBezierPath(rect: CGRect(origin: .zero, size: rect.size))
        let fullTextPath = UIBezierPath(rect: CGRect(x: 10, y: 10, width: 1000, height: 10))
        let fullTextPath_2 = UIBezierPath(rect: CGRect(x: 10, y: 15, width: 100, height: 10))
        fullTextPath.append(fullTextPath_2)
        
        let fullTextPath_3 = UIBezierPath(rect: CGRect(x: 10, y: 35, width: 100, height: 10))
        fullTextPath.append(fullTextPath_3)

        context.addPath(fullTextPath.cgPath)
//        context.setStrokeColor(UIColor.red.cgColor)
        context.setFillColor(UIColor.red.withAlphaComponent(0.1).cgColor)
        //`CGBlendMode.clear` 是 `CGBlendMode` 枚举中的一个值，它的效果是将结果设置为透明¹。在这种模式下，无论源图像样本是什么，结果都是透明的¹。这种模式通常用于擦除或清除图像的一部分⁴。在 `CGBlendMode.clear` 的等式中，R（结果）等于0¹。这意味着无论源图像或背景图像的颜色如何，最终的颜色都会是透明的¹。这在需要从图像中删除某些部分或创建非矩形图像时非常有用⁴。
  // https://blog.csdn.net/qq_14920635/article/details/75617188.
        context.setBlendMode(.clear)
        context.fillPath()
////        context.strokePath()
////        测试一下其他颜色
//        let fullTextPath_10 = UIBezierPath(rect: CGRect(x: 10, y: 30, width: 100, height: 10))
//        context.addPath(fullTextPath_10.cgPath)
////        context.setStrokeColor(UIColor.red.cgColor)
//        context.setFillColor(UIColor.green.cgColor)
//        context.setBlendMode(.normal)
//        //填充路径的区域
//        context.fillPath()
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
