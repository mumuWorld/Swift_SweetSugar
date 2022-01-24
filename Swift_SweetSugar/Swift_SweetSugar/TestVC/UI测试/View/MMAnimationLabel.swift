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
    
    override var text:String!{
        get {
            return super.text
        }
        set {
            super.text = text
            let attributedText = NSMutableAttributedString(string: newValue)
            let textRange = NSMakeRange(0,newValue.characters.count)
            attributedText.setAttributes([NSForegroundColorAttributeName:self.textColor], range: textRange)
            attributedText.setAttributes([NSFontAttributeName:self.font], range: textRange)
            let paragraphyStyle = NSMutableParagraphStyle()
            paragraphyStyle.alignment = self.textAlignment
            attributedText.addAttributes([NSParagraphStyleAttributeName:paragraphyStyle], range: textRange)
            self.attributedText = attributedText
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
            self.startAnimation { () -> () in
            }
            self.endAnimation(nil)
        }
    }
}

extension MMAnimationLabel: NSLayoutManagerDelegate {
    //Mark:NSLayoutMangerDelegate
    // 当 TextStorage 的文本内容改变时，会触发一个通知 send textLayoutManager 以便重新布局排版
    func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
            calculateTextLayers()
            print("\(textStorage.string)")
    }
        
        
    //MARK:CalculateTextLayer
    func calculateTextLayers() {
        newCharacterTextLayers.removeAll(keepCapacity:false)
            let attributedText = textStorage.string
    }
}
