//
//  MMTextVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/3.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMTextVC: UIViewController {
    @IBOutlet weak var xibTextView: UITextView!
    
    var storage: NSTextStorage = NSTextStorage()
    
//    var container: MMTextContainer = MMTextContainer(size: CGSize(300, 200))
    var container: NSTextContainer = NSTextContainer()
    
    var layout: NSLayoutManager = NSLayoutManager()
    
    var mmLayout: MMTextLayoutManager = MMTextLayoutManager()


    lazy var textView: UITextView = {
//        container.size = CGSize(width: 100,height: 200)
        mmLayout.addTextContainer(container)
        
        storage.addLayoutManager(mmLayout)

//        container.exclusionPaths = [UIBezierPath(roundedRect: CGRect(x: 10, y: 50, width: 100, height: 100), cornerRadius: 50)]
//        let item = UITextView(frame: CGRect(x: 10, y: 300, width: 300, height: 200), textContainer: container)
        let item = UITextView(frame: CGRect(x: 10, y: 300, width: 300, height: 200), textContainer: container)
        item.isScrollEnabled = true
        item.isEditable = false
        item.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        item.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.delegate = self
        view.addSubview(textView)
        
        let text = """
        In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        """
        textView.textContainer.exclusionPaths = [UIBezierPath(roundedRect: CGRect(x: 10, y: 50, width: 100, height: 100), cornerRadius: 50)]
//        storage.replaceCharacters(in: NSRange(location: 0, length: 0), with: text)
        
        textView.text = text
        
//        textView.layoutManager.addTextContainer(container)
         
        getText()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        mm_printLog(layout)
        mm_printLog(container)
    }
    
    func getText() {
        do {
            let path = Bundle.main.path(forResource: "textview", ofType: "json")!
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            let str = String(data: data, encoding: .utf8)
            textView.text = str
        } catch let e {
            mm_printLog(e)
        }
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
