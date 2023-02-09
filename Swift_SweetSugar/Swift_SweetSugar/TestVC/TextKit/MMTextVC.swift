//
//  MMTextVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/3.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import SnapKit

class MMTextVC: UIViewController {
    @IBOutlet weak var xibTextView: UITextView!
    
    var storage: NSTextStorage = NSTextStorage()
    
//    var container: MMTextContainer = MMTextContainer(size: CGSize(300, 200))
    var container: NSTextContainer = NSTextContainer()
    
    var layout: NSLayoutManager = NSLayoutManager()
    
    var mmLayout: MMTextLayoutManager = MMTextLayoutManager()


    lazy var textView: MMTextView = {
//        container.size = CGSize(width: 100,height: 200)
        mmLayout.addTextContainer(container)

        storage.addLayoutManager(mmLayout)

//        container.exclusionPaths = [UIBezierPath(roundedRect: CGRect(x: 10, y: 50, width: 100, height: 100), cornerRadius: 50)]
//        let item = UITextView(frame: CGRect(x: 10, y: 300, width: 300, height: 200), textContainer: container)
        let item = MMTextView(frame: .zero)
        item.font = UIFont.systemFont(ofSize: 30)
        item.textColor = UIColor.red.withAlphaComponent(0.5)
        item.tintColor = UIColor.green
        item.isScrollEnabled = false
        item.returnKeyType = .search
        item.isEditable = true
        item.keyboardDismissMode = .onDrag
        item.textContainer.lineFragmentPadding = 0
        item.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        item.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        item.textContainer.lineBreakMode = .byWordWrapping
        item.delegate = self
        return item
    }()
    
    lazy var textField: UITextField = {
        let item = UITextField()
        item.borderStyle = .line
        return item
    }()

    lazy var floatInput: MMFloatTextView = {
        let item = MMFloatTextView()
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout.delegate = self
        view.addSubview(textView)
        view.addSubview(textField)
        let text = """
        In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        """
//        textView.textContainer.exclusionPaths = [UIBezierPath(roundedRect: CGRect(x: 10, y: 50, width: 100, height: 100), cornerRadius: 50)]
//        storage.replaceCharacters(in: NSRange(location: 0, length: 0), with: text)
        
//        textView.text = text
        
//        textView.layoutManager.addTextContainer(container)
//        textView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(20)
//            make.top.equalToSuperview().offset(230)
//            make.width.equalTo(300)
//            make.height.equalTo(100)
//        }
        textView.frame = CGRect(x: 20, y: 230, width: 300, height: 100)
        textField.frame = CGRect(x: 20, y: 340, width: 300, height: 30)
//        getText()
//        pasteControl()
//        customMenu()
//        addObserve()
    }
    
    func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: UIApplication.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: UIApplication.keyboardDidHideNotification, object: nil)

    }
    
    @objc func handleNotification(sender: Notification) {
//        [AnyHashable(\"UIKeyboardIsLocalUserInfoKey\"): 1, AnyHashable(\"UIKeyboardAnimationDurationUserInfoKey\"): 0.25, AnyHashable(\"UIKeyboardAnimationCurveUserInfoKey\"): 7, AnyHashable(\"UIKeyboardFrameBeginUserInfoKey\"): NSRect: {{0, 812}, {375, 282}}, AnyHashable(\"UIKeyboardCenterBeginUserInfoKey\"): NSPoint: {187.5, 953}, AnyHashable(\"UIKeyboardBoundsUserInfoKey\"): NSRect: {{0, 0}, {375, 357}}, AnyHashable(\"UIKeyboardCenterEndUserInfoKey\"): NSPoint: {187.5, 633.5}, AnyHashable(\"UIKeyboardFrameEndUserInfoKey\"): NSRect: {{0, 455}, {375, 357}}]
        mm_printLog("test->\(sender.name), \(sender.userInfo)")
        guard let boardRect = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        switch sender.name {
        case UIApplication.keyboardWillShowNotification:
            floatInput.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(boardRect.height)
            }
        case UIApplication.keyboardWillHideNotification:
            floatInput.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
        default:
            break
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//        mm_printLog(layout)
//        mm_printLog(container)
        addFloatInput()
    }
    
    func addFloatInput() {
        view.addSubview(floatInput)
        floatInput.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
        floatInput.textView.becomeFirstResponder()
    }
    
//    override func buildMenu(with builder: UIMenuBuilder) {
//
//    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let str = NSStringFromSelector(action)
//        let str_ = NSStringFromSelector(#selector(copy()))
        mm_printLog(action)
//        if action == #selector(handleMyCopy(sender:)) {
//            return true
//        } else if action == #selector(handleTest(sender:)) {
//            return true
//        }
        if str == "paste:" {
            return true
        } else if str == "copy:" {
            return false
        }
//        if action == #selector(NSObject.copy) {
//            return false
//        }
        return false
    }
    
    override func copy(_ sender: Any?) {
        mm_printLog("")
    }
    
    func customMenu() {
            
        let menu = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(handleMyCopy(sender:)))
        let testItem = UIMenuItem(title: "测试", action: #selector(handleTest(sender:)))
        menu.menuItems = [copyItem, testItem]
        
    }
    
    
    func pasteControl() {
        if #available(iOS 16.0, *) {
            let confi : UIPasteControl.Configuration = UIPasteControl.Configuration()
            confi.cornerStyle = .capsule
            confi.displayMode = .iconAndLabel
            confi.baseForegroundColor = UIColor.blue
            confi.baseBackgroundColor = UIColor.red
            let control = UIPasteControl(configuration: confi)
            
            view.addSubview(control)
            control.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(200)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getText() {
        do {
            let path = Bundle.main.path(forResource: "textview", ofType: "json")!
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            let model = try JSONDecoder().decode(MMTextJson.self, from: data)
            let str = String(data: data, encoding: .utf8)
            textView.text = str
        } catch let e {
            mm_printLog(e)
        }
    }

}

extension MMTextVC {
    @objc func handleMyCopy(sender: AnyObject) {
        mm_printLog("test->\(sender)")
        
    }
    
    @objc func handleTest(sender: AnyObject) {
        mm_printLog("test->\(sender)")
        
    }
}

struct MMTextJson: Decodable {
    var input: String = "" {
        didSet {
            mm_printLog("text-> didSet")
        }
    }
    var test: String?
}

extension MMTextVC: UITextViewDelegate {
    /// 文字改变
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else { return }
        textView.attributedText = NSAttributedString(string: textView.text, attributes: [.font: UIFont.systemFont(ofSize: 40)])
    }
}

extension MMTextVC: NSLayoutManagerDelegate {
    
    /// optional
    /// - Parameters:
    ///   - layoutManager: <#layoutManager description#>
    ///   - glyphs: <#glyphs description#>
    ///   - props: <#props description#>
    ///   - charIndexes: <#charIndexes description#>
    ///   - aFont: <#aFont description#>
    ///   - glyphRange: <#glyphRange description#>
    /// - Returns: <#description#>
//    func layoutManager(_ layoutManager: NSLayoutManager, shouldGenerateGlyphs glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSLayoutManager.GlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: UIFont, forGlyphRange glyphRange: NSRange) -> Int {
//
//    }
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return CGFloat(glyphIndex * 1);
    }
}
