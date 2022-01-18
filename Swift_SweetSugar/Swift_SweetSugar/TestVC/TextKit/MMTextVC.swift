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

    lazy var textView: UITextView = {
//        container.size = CGSize(width: 100,height: 200)
        
        layout.addTextContainer(container)
        storage.addLayoutManager(layout)
        
//        container.exclusionPaths = [UIBezierPath(roundedRect: CGRect(x: 10, y: 50, width: 100, height: 100), cornerRadius: 50)]
//        let item = UITextView(frame: CGRect(x: 10, y: 300, width: 300, height: 200), textContainer: container)
        let item = UITextView(frame: CGRect(x: 10, y: 300, width: 300, height: 200))
        item.isScrollEnabled = true
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
        
        textView.layoutManager.addTextContainer(container)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog(layout)
        
        mm_printLog(container)
    }

}

extension MMTextVC: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return CGFloat(glyphIndex * 1);
    }
}
