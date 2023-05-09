//
//  MMTextContainer.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/14.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class MMTextContainer: NSTextContainer {
    
    /// 返回每行文本绘制的rect，这样我们改变rect的point就可以实现圆形文本了。
    /// - Parameters:
    ///   - proposedRect: <#proposedRect description#>
    ///   - characterIndex: <#characterIndex description#>
    ///   - baseWritingDirection: <#baseWritingDirection description#>
    ///   - remainingRect: <#remainingRect description#>
    /// - Returns: <#description#>
//    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
//        return super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
//        let size  = self.size
//
//        let rect = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
//
//        let radius = fmin(size.width, size.height)/2
//
//        let ypos = fabs((rect.origin.y + rect.size.height/2) - radius)
//
//        let width = (ypos < radius) ? 2 * sqrt(radius * radius - ypos * ypos) : 0.0
//
//        let finalRect = CGRect.init(x: rect.origin.x + radius - width/2.0, y: rect.origin.y, width: width, height: rect.size.height)
//
//        return finalRect
        
//    }
    
    /// 圆形文本展示
    /// - Parameters:
    ///   - proposedRect: <#proposedRect description#>
    ///   - characterIndex: <#characterIndex description#>
    ///   - baseWritingDirection: <#baseWritingDirection description#>
    ///   - remainingRect: <#remainingRect description#>
    /// - Returns: <#description#>
    override func lineFragmentRect(forProposedRect proposedRect: CGRect,
                                   at characterIndex: Int,
                                   writingDirection baseWritingDirection: NSWritingDirection,
                                   remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
        let rect = super.lineFragmentRect(forProposedRect: proposedRect,
                                          at: characterIndex,
                                          writingDirection: baseWritingDirection,
                                          remaining: remainingRect)
        // 每行会回调最少两次。
        mm_printLog("text: \(rect)")
        let containerWidth = Float(size.width), containerHeight = Float(size.height)

        let diameter = fminf(containerWidth, containerHeight)
        let radius = diameter / 2.0

        // Vertical distance from the line center to the container center.
        let yDistance = fabsf(Float(rect.origin.y + rect.size.height / 2.0) - radius)
        // The new line width.
        let width = (yDistance < radius) ? 2.0 * sqrt(radius * radius - yDistance * yDistance) : 0.0
        // Horizontal distance from rect.origin.x to the starting point of the line.
        let xOffset = (containerWidth > diameter) ? (containerWidth - diameter) / 2.0 : 0.0
        // The starting x of the line.
        let xPosition = CGFloat(xOffset + Float(rect.origin.x) + radius - width / 2.0)

        let resultRect = CGRect(x: xPosition, y: CGFloat(rect.origin.y), width: CGFloat(width), height: rect.size.height)
        mm_printLog("text: result = \(resultRect)")
        return resultRect
//        return rect
    }
    
}
