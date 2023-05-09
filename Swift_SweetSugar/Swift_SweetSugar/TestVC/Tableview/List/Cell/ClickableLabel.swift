//
//  ClickableLabel.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/4/23.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

class ClickableLabel: UILabel {
    
    var clickableText: String?
    var clickableTextAttributes: [NSAttributedString.Key: Any]?
    var tapAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == .ended {
            let tapLocation = tapGestureRecognizer.location(in: self)
            if let range = findClickableTextRange(),
               let clickableTextRect = rectForTextRange(range) {
                if clickableTextRect.contains(tapLocation) {
                    tapAction?()
                }
            }
        }
    }
    
    private func findClickableTextRange() -> NSRange? {
        if let clickableText = clickableText, let text = attributedText?.string {
            return (text as NSString).range(of: clickableText)
        }
        return nil
    }
    
    private func rectForTextRange(_ range: NSRange) -> CGRect? {
        guard let attributedText = attributedText else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}
