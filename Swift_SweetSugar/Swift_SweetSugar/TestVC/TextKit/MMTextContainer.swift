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
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
            let size  = self.size

            let rect = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)

            let radius = fmin(size.width, size.height)/2

            let ypos = fabs((rect.origin.y + rect.size.height/2) - radius)

            let width = (ypos < radius) ? 2 * sqrt(radius * radius - ypos * ypos) : 0.0

          let finalRect = CGRect.init(x: rect.origin.x + radius - width/2.0, y: rect.origin.y, width: width, height: rect.size.height)

            return finalRect

        }
}
