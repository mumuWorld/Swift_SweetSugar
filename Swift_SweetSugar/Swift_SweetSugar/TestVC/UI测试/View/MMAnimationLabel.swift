//
//  MMAnimationLabel.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/24.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class MMAnimationLabel: UILabel {
    let textStorage:NSTextStorage = NSTextStorage(string: "")
    let textLayoutManager:NSLayoutManager = NSLayoutManager()
    let textContainer:NSTextContainer = NSTextContainer()
   
    var oldCharacterTextLayers:[CATextLayer] = []
    var newCharacterTextLayers:[CATextLayer] = []
    
    override var text:String! {
        get {
            return super.text
        }
        set {
//            super.text = text
//            super.text = newValue
//            let attributedText = NSMutableAttributedString(string: newValue)
//            let textRange = NSMakeRange(0,newValue.characters.count)
//            attributedText.setAttributes([NSForegroundColorAttributeName:self.textColor], range: textRange)
//            attributedText.setAttributes([NSFontAttributeName:self.font], range: textRange)
//            let paragraphyStyle = NSMutableParagraphStyle()
//            paragraphyStyle.alignment = self.textAlignment
//            attributedText.addAttributes([NSParagraphStyleAttributeName:paragraphyStyle], range: textRange)
//            self.attributedText = attributedText
        }
        
    }
    
    override var attributedText:NSAttributedString!{
        get {
            return self.textStorage as NSAttributedString
        }
        set{
//            cleanOutOldCharacterTextLayers()
            oldCharacterTextLayers = Array(newCharacterTextLayers)
            textStorage.setAttributedString(newValue)
//            self.startAnimation { () -> () in
//            }
//            self.endAnimation(nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textKitObjectSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textKitObjectSetup() {
        textStorage.addLayoutManager(textLayoutManager)
        textLayoutManager.addTextContainer(textContainer)
        textLayoutManager.delegate = self
        textContainer.size = bounds.size
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
    }
}

extension MMAnimationLabel: NSLayoutManagerDelegate {
    //Mark:NSLayoutMangerDelegate
    // 当 TextStorage 的文本内容改变时，会触发一个通知 send textLayoutManager 以便重新布局排版
    func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
            calculateTextLayers()
            print("\(textStorage.string)")
    }
        
        
    //MARK:CalculateTextLayer。布局完成时调用
    func calculateTextLayers() {
        newCharacterTextLayers.removeAll(keepingCapacity: false)
        let attributedText = textStorage.string
        
//        let wordRange = NSMakeRange(0, attributedText.characters.count)
//        let attributedString = self.internalAttributedText();
//        let layoutRect = textLayoutManager.usedRect(for:textContainer)
//        var index = wordRange.location
//        let totalLength = NSMaxRange(wordRange)
//        while index < totalLength {
//
//        }
    }
}
