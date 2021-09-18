//
//  MMDottedLine.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/14.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import UIKit

/// 虚线绘制view
public class MMDottedLine: UIView {
    
    public enum LineType {
        case dot //圆点
    }
    
    public var lineDirection: NSLayoutConstraint.Axis = .horizontal
            
    public var phase: CGFloat = 0
    
    public var lineColor: UIColor = .red
    
    public var lineType: LineType = .dot
    
    public var lineWidth: CGFloat = 1
    
    var hasDraw = false
    
    public var reDrawInLayout: Bool = true
    
    var leftNumber: CGFloat = 2
    
    var rightNumber: CGFloat = 4
    
    public func drawLine() -> Void {
        guard !hasDraw else {
            return
        }
        UIGraphicsBeginImageContextWithOptions(mm_size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
//        let dot: CGFloat = 5, space: CGFloat = 3, dash: CGFloat = 12
//        let lineW = lineDirection == .horizontal ? mm_height : mm_width
//        lengths = [linew * dot, linew * space]
//        lengths = [linew * dash, linew * space, linew * dot, linew * space]
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(lineColor.cgColor)
        var lengths: [CGFloat] = []
        
        switch lineType {
        case .dot:
            lengths = [leftNumber, rightNumber]
        }
        
        context?.setLineDash(phase: lineWidth, lengths: lengths)
        context?.move(to: CGPoint(x: 0, y: 0))
        if lineDirection == .horizontal {
            context?.addLine(to: CGPoint(x: mm_width, y: 0))
        } else {
            context?.addLine(to: CGPoint(x: 0, y: mm_height))
        }
        context?.strokePath()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        layer.contents = img?.cgImage
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        hasDraw = false
        drawLine()
    }
}
