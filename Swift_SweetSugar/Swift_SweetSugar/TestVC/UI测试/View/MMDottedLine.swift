//
//  MMDottedLine.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/4/1.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMDottedLine: UIView {

    var lineDirection: NSLayoutConstraint.Axis = .horizontal
        
    var lengths: [CGFloat] = [40, 24]
    
    var phase: CGFloat = 0
    
    var lineColor: UIColor = .red
    
//    var <#name#> = <#value#>
    
    
    func test() -> Void {
        UIGraphicsBeginImageContextWithOptions(mm_size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        let dot: CGFloat = 5, space: CGFloat = 3, dash: CGFloat = 12
        let linew: CGFloat = 3;
//        let lineW = lineDirection == .horizontal ? mm_height : mm_width
//        lengths = [linew * dot, linew * space]
//        lengths = [linew * dash, linew * space, linew * dot, linew * space]
        lengths = [linew * 0, linew * 3]
        context?.setLineWidth(linew)
        context?.setStrokeColor(lineColor.cgColor)
        context?.setLineDash(phase: linew, lengths: lengths)
        context?.move(to: CGPoint(x: 0, y: 1))
        if lineDirection == .horizontal {
            context?.addLine(to: CGPoint(x: mm_width, y: 1))
        } else {
            context?.addLine(to: CGPoint(x: 0, y: mm_height))
        }
        context?.strokePath()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        layer.contents = img?.cgImage
    }

}
