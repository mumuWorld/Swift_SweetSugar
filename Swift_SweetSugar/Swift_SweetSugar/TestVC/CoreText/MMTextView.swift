//
//  MMTextView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/10/8.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMTextView: UITextView {
    
    var isAutoLayoutHeight: Bool = true

    var attributeString: NSAttributedString? {
        didSet {
            mm_printLog("赋值->")
        }
    }
    
    private var _delegate: UITextViewDelegate?
    override var delegate: UITextViewDelegate? {
        set {
            _delegate = newValue
        }
        get {
            return super.delegate
        }
    }
    
    override open var contentSize: CGSize {
        didSet {
            if abs(contentSize.height - oldValue.height) > 1.0 {
                self.setNeedsLayout()
                if isAutoLayoutHeight {
                    invalidateIntrinsicContentSize()
                }
            }
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        if isAutoLayoutHeight {
            return contentSize
        }
        return super.intrinsicContentSize
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
        returnKeyType = .done
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 换行时不会调用。
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        mm_printLog("test->")
        return true
    }
    //    @objc func _wantsForwardingFromResponder(_ arg1: UIResponder, toNextResponder  arg2: UIResponder, withEvent arg3: UIEvent) -> Bool {
//        let classStr = String(describing: arg2.self)
//        if classStr == "_UIRemoteInputViewController" {
//            return true
//        }
//        return super.perform(#selector(_wantsForwardingFromResponder(arg1, toNextResponder: arg2, withEvent: arg3)))
//    }
    
//    - (BOOL)_wantsForwardingFromResponder:(UIResponder *)arg1 toNextResponder:(UIResponder *)arg2 withEvent:(UIEvent *)arg3 {
//        NSString* responderClassName = NSStringFromClass([arg2 class]);
//        if ([responderClassName isEqualToString:@"_UIRemoteInputViewController"]) {
//            if (_objc_rootIsDeallocating(arg2)) {
//                NSLog(@"BingGo a deallocating object ...");
//                return true;
//            }
//        }

//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        mm_printLog("test->\(action), sender=\(sender)")
//        if action == #selector(MMTextVC.handleMyCopy(sender:)) {
//            return true
//        } else if action == #selector(MMTextVC.handleTest(sender:)) {
//            return true
//        }
//        return false
//    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        guard let attrStr = attributeString, let context = UIGraphicsGetCurrentContext() else { return }
//        let after = rect.applying(CGAffineTransform(scaleX: 1.0, y: -1))
//        let path = CGPath(rect: after, transform: nil)
//        let framesetter = CTFramesetterCreateWithAttributedString(attrStr)
//        let ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), path, nil)
//
//        //翻转坐标系 ->下移y 然后翻转y
//        context.textMatrix = .identity
//        context.translateBy(x: 0, y: rect.height)
//        context.scaleBy(x: 1.0, y: -1.0)
//
//
//        //第一种 利用 CTFrameDraw
////        CTFrameDraw(ctFrame, context)
//
//        let lines = CTFrameGetLines(ctFrame)
//        let linesCount = CFArrayGetCount(lines)
//        var points: [CGPoint] = [CGPoint](repeating: .zero, count: linesCount)
//        CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, linesCount), &points)
//        //第二种 利用 CTLineDraw
////        for i in 0..<linesCount {
////            let origin = points[i]
////            context.textPosition = origin
////            let linePointer = CFArrayGetValueAtIndex(lines, i)
////            //强转
////            let line = unsafeBitCast(linePointer, to: CTLine.self)
////                CTLineDraw(line, context)
////        }
//
//        //第三种 利用 CTRunDraw
//        for i in 0..<linesCount {
//            context.textPosition = points[i]
//            let linePointer = CFArrayGetValueAtIndex(lines, i)
//            let line = unsafeBitCast(linePointer, to: CTLine.self)
//            if let runs = CTLineGetGlyphRuns(line) as? [CTRun] {
//                for j in 0..<runs.count {
//                    CTRunDraw(runs[j], context, CFRangeMake(0, 0))
//                }
//            }
//
//        }
//
//
//        mm_printLog("画完->")
//    }
}

extension MMTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print("test->textView: selectedRange: \(textView.selectedRange), markedTextRange: \(textView.markedTextRange), selectedTextRange: \(textView.selectedTextRange)")
    }
}

//extension MMTextView {
//    @objc func handleMyCopy(sender: AnyObject) {
//        mm_printLog("test->\(sender)")
//
//    }
//
//    @objc func handleTest(sender: AnyObject) {
//        mm_printLog("test->\(sender)")
//
//    }
//}
